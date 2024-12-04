# Music Genre Classification App
![Picture of App](https://github.com/gzmanbrc/Signal-Systems-Music-Classification-Project/blob/main/MatlabApp.png?raw=true)

This project was developed as part of the **Signal and Systems** course. It is designed to demonstrate the application of signal processing techniques and machine learning for music genre classification.This project is a MATLAB application that allows users to upload an audio file and predict its genre using a trained machine learning model. Users can upload a WAV format audio file, then use a trained model to predict the genre of the file. Additionally, the spectrogram of the uploaded audio can be visualized.

## Features
- **WAV file upload**: Users can select a WAV audio file from their computer.
- **Model upload**: Users can upload a `.mat` model file to use a trained machine learning model.
- **Music genre prediction**: Users can predict the genre of the audio file using the loaded model.
- **Spectrogram visualization**: The spectrogram of the audio file is generated and displayed visually.

## Requirements
This application requires MATLAB and the following dependencies:
- MATLAB (version R2021a or later is recommended)
- `audioread` function (for reading audio files)
- `.mat` model files (to load trained models)

## Usage
1. **Starting the Application**:
   - Run the project in MATLAB to start the GUI.
   - Once the main window opens, you will need to upload an audio file and a trained model.

2. **Uploading a WAV File**:
   - Click the "Select WAV file" button to choose a WAV file.
   - The genre of the selected file will be displayed under the `Genre` label.

3. **Uploading a Model**:
   - Click the "Load Model" button to select a trained model file (it should have a `.mat` extension).
   - The name of the loaded model will be displayed under the `Model Name` label.

4. **Predicting the Genre**:
   - Click the "Predict Genre" button to predict the genre of the uploaded audio file using the loaded model.
   - The result will be displayed (note that additional code for showing the result could be added if needed).

5. **Viewing the Spectrogram**:
   - The spectrogram of the uploaded audio file will be displayed in the graphical area (UIAxes) at the bottom of the application.

## Application Interface
The application consists of the following components:
- **Select WAV file**: Button to upload a WAV audio file.
- **Load Model**: Button to upload a trained model file.
- **Predict Genre**: Button to predict the genre of the uploaded audio file.
- **UIAxes**: Area where the spectrogram of the audio file is displayed.
- **Model Name**: Displays the name of the loaded model.
- **Genre**: Displays the predicted genre of the uploaded audio file.
