classdef app2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        PredictGenreButton           matlab.ui.control.Button
        LoadModelButton              matlab.ui.control.Button
        ModelNameLabel               matlab.ui.control.Label
        DropDown                     matlab.ui.control.DropDown
        DropDownLabel                matlab.ui.control.Label
        GenreLabel                   matlab.ui.control.Label
        LoadaWAVfileandpredictitgenreLabel  matlab.ui.control.Label
        MusicClassificationAppLabel  matlab.ui.control.Label
        SelectWAVfileButton          matlab.ui.control.Button
        UIAxes                       matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        SelectedFile % Description
        AudioData % Description
        FileLabel % Description
        ModelDropDown
        TrainedNet % Yüklenen modelin içeriği
        TrainedNetFile % Yüklenen model dosyasının tam yolu% Description
        %ModelNameLabel % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectWAVfileButton
        function SelectWAVfileButtonPushed(app, event)
          
    [file, path] = uigetfile('*.wav', 'Select a WAV File');
    if isequal(file, 0)
        return;
    end
    app.SelectedFile = fullfile(path, file); % Save the file path
    app.AudioData = audioread(app.SelectedFile); % Read the audio data
    app.GenreLabel.Text = ['Genre: ', file]; % Update label


        end

        % Button pushed function: LoadModelButton
        function LoadModelButtonPushed(app, event)
    % Button: Model Yükle
    % Dosya seçme penceresi aç
    [file, path] = uigetfile('*.mat', 'Select a model file');
    if isequal(file, 0)
        % Kullanıcı bir dosya seçmediyse uyarı ver
        uialert(app.UIFigure, 'Model file not selected.', 'Warning');
        return;
    end
    
    % Seçilen dosyayı yükle
    fullPath = fullfile(path, file);
    try
        loadedData = load(fullPath);
    catch
        uialert(app.UIFigure, 'Failed to load model file. Make sure you choose a valid .mat file.', 'Error');
        return;
    end
    
    % Modeli uygulamanın bir özelliğine ata
    app.TrainedNet = loadedData;
    app.TrainedNetFile = fullPath; % Yüklenen dosyanın tam yolunu sakla

    % Dosya adını bir Label bileşeninde göster
    [~,modelName, ~] = fileparts(file);
    app.ModelNameLabel.Text = ['Model Name: ',modelName];

        end

        % Button pushed function: PredictGenreButton
        function PredictGenreButtonPushed(app, event)
            

    % Kullanıcının bir ses dosyası yüklediğini kontrol edin
    if isempty(app.AudioData)
        uialert(app.UIFigure, 'Please upload an audio file.', 'Warning');
        return;
    end
    
    % Model yüklenip yüklenmediğini kontrol edin
    if isempty(app.TrainedNetFile)
        uialert(app.UIFigure, 'Please upload a model file .mat.', 'Warning');
        return;
    end

    % Spektrogram oluştur
    windowLength = 1024;
    overlap = round(0.75 * windowLength);
    nfft = 1024;
    fs = 44100; % Örnekleme frekansı
    [S, F, T] = spectrogram(app.AudioData, windowLength, overlap, nfft, fs);
    logSpectrogram = log10(abs(S) + 1e-6);

    % Spektrogram'ı UIAxes'te görüntüle
    imagesc(app.UIAxes, T, F, logSpectrogram);
    axis(app.UIAxes, 'xy');
    title(app.UIAxes, 'Log-Spektrogram');
    xlabel(app.UIAxes, 'Zaman (s)');
    ylabel(app.UIAxes, 'Frekans (Hz)');
    colorbar(app.UIAxes);

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Spectrogram View')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Frequency')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [288 150 300 185];

            % Create SelectWAVfileButton
            app.SelectWAVfileButton = uibutton(app.UIFigure, 'push');
            app.SelectWAVfileButton.ButtonPushedFcn = createCallbackFcn(app, @SelectWAVfileButtonPushed, true);
            app.SelectWAVfileButton.Position = [71 299 100 22];
            app.SelectWAVfileButton.Text = 'Select WAV file';

            % Create MusicClassificationAppLabel
            app.MusicClassificationAppLabel = uilabel(app.UIFigure);
            app.MusicClassificationAppLabel.FontSize = 16;
            app.MusicClassificationAppLabel.Position = [71 412 182 22];
            app.MusicClassificationAppLabel.Text = 'Music Classification App';

            % Create LoadaWAVfileandpredictitgenreLabel
            app.LoadaWAVfileandpredictitgenreLabel = uilabel(app.UIFigure);
            app.LoadaWAVfileandpredictitgenreLabel.Position = [71 366 383 22];
            app.LoadaWAVfileandpredictitgenreLabel.Text = 'Load a WAV file and predict it genre.';

            % Create GenreLabel
            app.GenreLabel = uilabel(app.UIFigure);
            app.GenreLabel.Position = [71 230 189 22];
            app.GenreLabel.Text = 'Genre: -';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [194 86 66 22];
            app.DropDownLabel.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Fine Tree', 'Medium Tree', 'Coarse Tree', 'Linear SVM', 'Quadra c SVM', 'Fine KNN', 'Medium KNN', 'Coarse KNN', 'Boosted Trees', 'Narrow Neural', 'Network', 'Medium Neural', 'Network'};
            app.DropDown.Position = [275 86 100 22];
            app.DropDown.Value = 'Fine Tree';

            % Create ModelNameLabel
            app.ModelNameLabel = uilabel(app.UIFigure);
            app.ModelNameLabel.Position = [71 150 213 22];
            app.ModelNameLabel.Text = 'Model Name: -';

            % Create LoadModelButton
            app.LoadModelButton = uibutton(app.UIFigure, 'push');
            app.LoadModelButton.ButtonPushedFcn = createCallbackFcn(app, @LoadModelButtonPushed, true);
            app.LoadModelButton.Position = [71 181 100 22];
            app.LoadModelButton.Text = 'Load Model';

            % Create PredictGenreButton
            app.PredictGenreButton = uibutton(app.UIFigure, 'push');
            app.PredictGenreButton.ButtonPushedFcn = createCallbackFcn(app, @PredictGenreButtonPushed, true);
            app.PredictGenreButton.Position = [71 261 100 22];
            app.PredictGenreButton.Text = 'Predict Genre';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end