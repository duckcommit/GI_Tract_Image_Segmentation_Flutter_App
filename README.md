# GI Tract Image Segmentation Flutter App

First of all, shout out to @Arlendious for providing the ML model.

The GI Tract Image Segmentation Flutter App is a medical application designed to assist healthcare professionals in segmenting MRI scans of the gastrointestinal tract. This automated tool uses machine learning to identify areas that require surgical intervention, ensuring a more efficient and precise approach to cancer treatment.

# Key Features

User Authentication: Healthcare professionals can sign up and log in using their organization email addresses, which are hardcoded for security. Email verification is implemented via OTP.

Dashboard: Users have access to a user-friendly dashboard where they can upload MRI scans for segmentation.

Automated Image Segmentation: The app uses a machine learning model to automatically segment MRI scans and identify areas that require surgical attention.

Secure Data Storage: All segmented images are securely stored in phone storage for future reference.

# Tech Stack

Flutter: A popular open-source framework for building natively compiled applications for mobile, web, and desktop from a single codebase.

FastAPI: A modern, fast (high-performance), web framework for building APIs with Python 3.6+ based on standard Python type hints.

Azure Cloud: Provides cloud-based services for machine learning model deployment and scalability.

Docker: Used for containerization and packaging the application for easy deployment.

Firebase: Provides user authentication and OTP verification.

Firestore: A NoSQL database for storing and managing user data and segmented images.


# Getting Started

1) Clone this repository to your local machine.
```bash
git clone https://github.com/duckcommit/GI_Tract_Image_Segmentation_Flutter_App.git
```

2) Install the necessary dependencies
```bash
  flutter pub get
```

3) Run the app
```bash
  flutter run
```

It is note that the app might not work if the Azure Cloud services are facing any issues.
# Need Help? 🔗 Link
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/vyshnav-ajith/)

Feel free to contact for any help or if you wish to collaborate. 

