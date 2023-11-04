# import uvicorn
from fastapi import FastAPI, HTTPException
# from TestModel import TestParams
import tensorflow as tf
from pydantic import BaseModel
import numpy as np
from glob import glob
import cv2
BATCH_SIZE = 1
im_width:int = 256
im_height:int = 256
app = FastAPI()
import pandas as pd
import json
from datetime import datetime
from keras import backend as K
import urllib.request
import os
import matplotlib.gridspec as gridspec
import matplotlib.patches as mpatches
import matplotlib as mpl
import matplotlib.pyplot as plt
from firebase_admin import credentials, initialize_app, storage

cred = credentials.Certificate("givision-fe9688e69cf6.json")
initialize_app(cred, {'storageBucket': 'givision.appspot.com'})
bucket = storage.bucket()
# Run-length encoding
im_width = 256
im_height = 256
class TestParams(BaseModel):
    image: str
def rle_encode(img):
    '''
    img: numpy array, 1 - mask, 0 - background
    Returns run length as string formated
    '''
    pixels = img.flatten()
    pixels = np.concatenate([[0], pixels, [0]])
    runs = np.where(pixels[1:] != pixels[:-1])[0] + 1
    runs[1::2] -= runs[::2]
    
    return ' '.join(str(x) for x in runs)

# Metadata
def preprocessing(df, subset="train"):
    case = df['id'][0].split("_")[0].split("case")[1]
    day = df['id'][0].split("_")[1].split("_")[0].split("day")[1]
    slice = df['id'][0].split("_")[3]
    #--------------------------------------------------------------------------
    df["case"] = case
    df["day"] = day
    df["slice"] = slice
    #--------------------------------------------------------------------------
    #--------------------------------------------------------------------------
    #--------------------------------------------------------------------------
    #--------------------------------------------------------------------------
    
    return df

# Restructure
def restructure(df, subset="train"):
    # RESTRUCTURE  DATAFRAME
    df_out = pd.DataFrame({'id': df['id'][::3]})

    if subset=="train":
        df_out['large_bowel'] = df['segmentation'][::3].values
        df_out['small_bowel'] = df['segmentation'][1::3].values
        df_out['stomach'] = df['segmentation'][2::3].values

    df_out['path'] = df['path'][::3].values
    df_out['case'] = df['case'][::3].values
    df_out['day'] = df['day'][::3].values
    df_out['slice'] = df['slice'][::3].values
    df_out['width'] = df['width'][::3].values
    df_out['height'] = df['height'][::3].values

    df_out=df_out.reset_index(drop=True)
    df_out=df_out.fillna('')
    if subset=="train":
        df_out['count'] = np.sum(df_out.iloc[:,1:4]!='',axis=1).values
    
    return df_out

def rle_decode(mask_rle, shape, color=1):
    '''
    mask_rle: run-length as string formated (start length)
    shape: (height,width) of array to return
    Returns numpy array, 1 - mask, 0 - background
    '''
    s = mask_rle.split()
    starts, lengths = [np.asarray(x, dtype=int) for x in (s[0:][::2], s[1:][::2])]
    starts -= 1
    ends = starts + lengths
    img = np.zeros((shape[0] * shape[1], shape[2]), dtype=np.float32)
    for lo, hi in zip(starts, ends):
        img[lo : hi] = color
    return img.reshape(shape)

def dice_coef(y_true, y_pred, smooth=1):
    y_true_f = K.flatten(y_true)
    y_pred_f = K.flatten(y_pred)
    intersection = K.sum(y_true_f * y_pred_f)
    return (2. * intersection + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth)

def iou_coef(y_true, y_pred, smooth=1):
    intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
    union = K.sum(y_true,[1,2,3])+K.sum(y_pred,[1,2,3])-intersection
    iou = K.mean((intersection + smooth) / (union + smooth), axis=0)
    return iou

def dice_loss(y_true, y_pred):
    smooth = 1.
    y_true_f = K.flatten(y_true)
    y_pred_f = K.flatten(y_pred)
    intersection = y_true_f * y_pred_f
    score = (2. * K.sum(intersection) + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth)
    return 1. - score

def focal_dice_loss(y_true, y_pred, gamma=2.0, alpha=0.25):
    epsilon = K.epsilon()
    y_true = K.flatten(y_true)
    y_pred = K.flatten(y_pred)

    pt_1 = y_true * y_pred + (1 - y_true) * (1 - y_pred)
    pt_1 = K.clip(pt_1, epsilon, 1 - epsilon)
    focal_loss = -alpha * K.pow(1 - pt_1, gamma) * K.log(pt_1)

    return K.mean(dice_loss(tf.cast(y_true, tf.float32), y_pred) + focal_loss)

def focal_loss(y_true, y_pred, gamma=2.0, alpha=0.25):
    epsilon = K.epsilon()
    y_true = K.flatten(y_true)
    y_pred = K.flatten(y_pred)

    pt_1 = y_true * y_pred + (1 - y_true) * (1 - y_pred)
    pt_1 = K.clip(pt_1, epsilon, 1 - epsilon)
    focal_loss = -alpha * K.pow(1 - pt_1, gamma) * K.log(pt_1)

    return 270*(K.mean(focal_loss))

# Images reshaped to (im_height,im_width)
class DataGenerator(tf.keras.utils.Sequence):
    def __init__(self, df, batch_size = BATCH_SIZE, subset="train", shuffle=False):
        super().__init__()
        self.df = df
        self.shuffle = shuffle
        self.subset = subset
        self.batch_size = batch_size
        self.indexes = np.arange(len(df))
        self.on_epoch_end()

    def __len__(self):
        return int(np.floor(len(self.df) / self.batch_size))
    
    def on_epoch_end(self):
        if self.shuffle == True:
            np.random.shuffle(self.indexes)
    
    def __getitem__(self, index):
        X = np.empty((self.batch_size,im_height,im_width,3))
        y = np.empty((self.batch_size,im_height,im_width,3))
        indexes = self.indexes[index*self.batch_size:(index+1)*self.batch_size]
        for i, img_path in enumerate(self.df['path'].iloc[indexes]):
            w=self.df['width'].iloc[indexes[i]]
            h=self.df['height'].iloc[indexes[i]]
            img = self.__load_grayscale(img_path)  # shape: (im_height,im_width,1)
            X[i,] = img   # broadcast to shape: (im_height,im_width,3)
            if self.subset == 'train':
                for k,j in enumerate(["large_bowel","small_bowel","stomach"]):
                    rles = self.df[j].iloc[indexes[i]]
                    mask = rle_decode(rles, shape=(int(h), int(w), int(1)))
                    mask = cv2.resize(mask, (im_height,im_width))
                    y[i,:,:,k] = mask
        if self.subset == 'train':
            return X, y
        else: 
            return X
        
        # To do: add data augmentation
        
    def __load_grayscale(self, img_path):
        img = cv2.imread(img_path, cv2.IMREAD_UNCHANGED)
        #min_16bit = np.min(img)
        #max_16bit = np.max(img)
        #img = np.array(np.rint((255 * (img - min_16bit)) / float(max_16bit - min_16bit)), dtype=np.uint8)
        img = cv2.normalize(img, None, 0, 255, cv2.NORM_MINMAX, dtype=cv2.CV_8U)
        dsize = (im_height,im_width)
        img = cv2.resize(img, dsize)
        img = img.astype(np.float32) / 255.
        img = np.expand_dims(img, axis=-1)
        return img

@app.get('/')
def index():
    return{'message':"Hello, world"}

@app.get('/Welcome')
def get_name(name:str):
    return{"Hello":f'{name}'}

@app.post('/predict')
async def process_predict(data:TestParams):

# Load trained model
    custom_objects = custom_objects={
        'dice_coef': dice_coef,
        'iou_coef': iou_coef,
        'focal_loss': focal_loss,
        'focal_dice_loss': focal_dice_loss
    }
    mlModel = tf.keras.models.load_model('app/Light_Unet.h5', custom_objects=custom_objects) 
    # preprocessing the image
     # we are expecting data.image to be url of the image
    # test_df = pd.DataFrame({'image_path': [image]})
    image_path = 'test_image'+str(datetime.now().second)+'.png'
    urllib.request.urlretrieve(data.image, image_path)

    test_df = pd.DataFrame({'image_path': [image_path],
                   'height': [256],
                   'width': [256],
                   'id': ['case123_day20_slice_0107'],
                   'path': image_path})
    # print(test_df.head())
    pred_batches = DataGenerator(test_df, batch_size = BATCH_SIZE, subset="test", shuffle=False)
    num_batches = int(len(test_df)/BATCH_SIZE)

    for i in range(num_batches):
        # Predict
        preds = mlModel.predict(pred_batches[i],verbose=0)     
    
        # Rle encode
        for j in range(BATCH_SIZE):
            for k in range(3):
                pred_img = cv2.resize(preds[j,:,:,k], (int(test_df.loc[i*BATCH_SIZE+j,'width']), int(test_df.loc[i*BATCH_SIZE+j,"height"])), interpolation=cv2.INTER_NEAREST) # resize probabilities to original shape
                pred_img = (pred_img>0.5).astype(dtype='uint8')    # classify
                test_df.loc[3*(i*BATCH_SIZE+j)+k,'predicted'] = rle_encode(pred_img)

    test_new = preprocessing(test_df, subset="train")
    test_new = test_new.rename(columns={'predicted': 'segmentation'})
    test_new = restructure(test_new, subset="train")

    pred_batches = DataGenerator(test_new.iloc[0:1,:], batch_size = 1, subset="train", shuffle=False)
    preds = mlModel.predict_generator(pred_batches,verbose=1)

    Threshold = 0.5
    # Visualizing
    fig = plt.figure(figsize=(10, 25))
    gs = gridspec.GridSpec(nrows=8, ncols=3)
    colors = ['yellow','green','red']
    labels = ["Large Bowel", "Small Bowel", "Stomach"]
    patches = [ mpatches.Patch(color=colors[i], label=f"{labels[i]}") for i in range(len(labels))]

    cmap1 = mpl.colors.ListedColormap(colors[0])
    cmap2 = mpl.colors.ListedColormap(colors[1])
    cmap3= mpl.colors.ListedColormap(colors[2])

    for i in range(1):
        images, mask = pred_batches[i]
        sample_img=images[0,:,:,0]
        mask1=mask[0,:,:,0]
        mask2=mask[0,:,:,1]
        mask3=mask[0,:,:,2]

        pre=preds[i]
        predict1=pre[:,:,0]
        predict2=pre[:,:,1]
        predict3=pre[:,:,2]

        predict1= (predict1 > Threshold).astype(np.float32)
        predict2= (predict2 > Threshold).astype(np.float32)
        predict3= (predict3 > Threshold).astype(np.float32)

        ax0 = fig.add_subplot(gs[i, 0])
        im = ax0.imshow(sample_img, cmap='bone')
        ax0.set_title("Image", fontsize=12, y=1.01)
        #--------------------------
        ax2 = fig.add_subplot(gs[i, 2])
        ax2.set_title("Image with Mask", fontsize=12, y=1.01)
        l0 = ax2.imshow(sample_img, cmap='bone')
        l1 = ax2.imshow(np.ma.masked_where(predict1== False,  predict1),cmap=cmap1, alpha=1)
        l2 = ax2.imshow(np.ma.masked_where(predict2== False,  predict2),cmap=cmap2, alpha=1)
        l3 = ax2.imshow(np.ma.masked_where(predict3== False,  predict3),cmap=cmap3, alpha=1)
    
        _ = [ax.set_axis_off() for ax in [ax0,ax2]]
        colors = [im.cmap(im.norm(1)) for im in [l1,l2, l3]]
        plt.legend(handles=patches, bbox_to_anchor=(1.1, 0.65), loc=2, borderaxespad=0.4,fontsize = 12,title='Mask Labels', title_fontsize=12, edgecolor="black",  facecolor='#c5c6c7')
        save_image_path = 'save_image'+str(datetime.now().second)+'.png'
        plt.savefig(save_image_path, dpi=300, bbox_inches='tight')
        plt.close(fig)
        # Init firebase with your credentials
        blob = bucket.blob(save_image_path)
        blob.upload_from_filename(save_image_path)

        # Opt : if you want to make public access from the URL
        blob.make_public()
        image_url = blob.public_url

        os.remove(save_image_path)
        os.remove(image_path)
        #output = mlModel.predict(processed_data)
        return {
            'image_url':image_url
        }
    return HTTPException(400, 'Error Occured')

#docker pull 
#docker run -p 8000:8000
#docker run -p 8000:8000 -d vyshaj/project-image