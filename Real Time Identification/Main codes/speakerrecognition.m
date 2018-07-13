clc;
close all;
choices=0;
possibilities=6;
global v
load V
addpath('library');
Fs=16000; %sampling frequency
Bits_no = 16;  %bits per sample
while choices~=possibilities
    choices=menu('Speaker Identification Application','New Database/Add Sample',...
        'Recognition Input','Load a sound from microphone for testing',...
        'Database Information','Delete Database','Exit');
%------------------------------------------------------------------%   
    % 
    if choices==1
        clc;
        close all;
        if (exist('sound_database.dat')==2)
            load('sound_database.dat','-mat');           
            duration=input('Enter the duration of the Recording (in seconds):');   
            message=strcat('Parameters Used for Recording: Sampling frequency:',num2str(Fs));
            disp(message);
            message=strcat('Bits per sample:',num2str(Bits_no));
            disp(message);
            disp('Speak into microphone after bleep...');
            bleep=audioread('bleep2.wav');
            bleep=audioplayer(bleep,Fs);
            play(bleep);
            mic_recorder = audiorecorder(Fs,Bits_no,2);   
            
            record(mic_recorder,duration);
            while (isrecording(mic_recorder)==1)
                disp('Recording...');
                pause(0.3);
            end
            disp('Recording stopped.');
            y = getaudiodata(mic_recorder);
            figure(1),plot(y);
            if size(y,2)==2
                y=y(:,1);
            end
            y = double(y);     
            sound_number = sound_number+1;
            data{sound_number,1} = y;
            data{sound_number,2} = sound_number;
            data{sound_number,3} = duration;
            data{sound_number,4} = 'Microphone';
            save('sound_database.dat','data','sound_number','-append');
            msgbox('Sound added to Database','Database result','help');
            disp('Sound added to Database');
            
        else %-----If no DB exists then creats a DB file.           
            duration = input('Enter the duration of the Recording (in seconds):');                                   
            disp('Using Sampling Frequency: 16000');            
            disp('Number of bits per sample: 16');
            disp('Speak into microphone after bleep...');
            bleep = audioread('bleep2.wav');
            bleep = audioplayer(bleep,Fs);
            play(bleep);
            mic_recorder = audiorecorder(Fs,Bits_no,2);
                        
            record(mic_recorder,duration);   
            while (isrecording(mic_recorder)==1) 
                disp('Recording...');
                pause(0.3);
            end
            disp('Recording stopped.');
            y =getaudiodata(mic_recorder); 
            figure(1),plot(y);
            if size(y,2)==2
                y=y(:,1);
            end
            y = double(y);            
            sound_number = 1;
            data{sound_number,1} = y;
            data{sound_number,2} = sound_number ;
            data{sound_number,3} = duration;
            data{sound_number,4} = 'Microphone';
            save('sound_database.dat','data','sound_number','Fs','Bits_no');
            msgbox('Sound added to Database','Database result','help');
            disp('Sound added to Database');
        end
    end
    %----------------------------------------------------------------------
    % % 'Recognition input'
    if choices==2
        clc;
        close all;
        if (exist('sound_database.dat')==2)
            load('sound_database.dat','-mat');           
            duration=input('Enter the duration of the Recording (in seconds):');
            disp('Speak into microphone after bleep...');
            bleep=audioread('bleep2.wav');
            bleep=audioplayer(bleep,Fs);
            play(bleep);
            mic_recorder = audiorecorder(Fs,Bits_no,2);
            
            record(mic_recorder,duration);
            while (isrecording(mic_recorder)==1)
                disp('Recording...');
                pause(0.3);
            end
            disp('Recording stopped.');
            
            y = getaudiodata(mic_recorder);
            figure(1),plot(y);
            % if the input sound is not mono
            if size(y,2)==2
                y=y(:,1);
            end
            y = double(y);
            
            %----- code for speaker recognition -------
            disp('I-Vector Computation and VQ Codebook training is in Progress...');
            disp(' ');
            k =16;         % Number of centroids required
             for ii=1:1:sound_number                
                   v = mfcc(data{ii,1},Fs);
                   [N, F] = compute_bw_stats(v,'ubm');
                   model = extract_ivector([N; F], 'ubm', 'T');
                   model = V' * model;                   
                   code{ii} = vqlbg(model, k); % Train VQ codebook
                   disp('...');
             end
             
            disp('Training Process Completed.');
            
            v = mfcc(y,Fs);         % Compute MFCC coefficients for input sound
            [N, F] = compute_bw_stats(v,'ubm');
            model = extract_ivector([N; F], 'ubm', 'T');
            model = V' * model;   
            % Current distance and sound ID initialization
            distmin = Inf;           
            for ii=1:sound_number
                d  = disteu(model, code{ii},0);
                dist = sum(min(d,[],2)) / size(d,1);
                if dist < distmin
                    distmin = dist;                    
                    min_index = ii;
                    speech_id = data{min_index,2};
                end
            end

            %-----------------------------------------
            if distmin < 5
            disp('Matching sound:');
            message=strcat('File & Location:',data{min_index,4});
            disp(message);
            message=strcat('Duration of Signal:',num2str(data{min_index,3}));
            disp(message);
            message = strcat('Recognized speaker ID: ',num2str(speech_id));
            disp(message);
            msgbox(message,'Matching result','help');
            else
                disp('No match Found');
                msgbox('No Matches found','warning');
            end
        else
            warndlg('Database is empty. No matching is possible.',' Warning ')
        end
    end
 %-------------------------------------------------------------------------
 
    % Load a sound from microphone for testing
    if choices==3
        clc;
        close all;
        duration = input('Enter the duration of the Recording (in seconds):');              
        disp('Speak into microphone after bleep...');
        bleep=audioread('bleep2.wav');
        bleep=audioplayer(bleep,Fs);
        play(bleep);
        mic_recorder = audiorecorder(Fs,Bits_no,2); 
        
        record(mic_recorder,duration);
        while (isrecording(mic_recorder)==1)
            disp('Recording...');
            pause(0.3);
        end
        disp('Recording stopped.');
        disp('Playing recorded voice...');
        speechplayer = play(mic_recorder);
        pause(duration);
        stop(speechplayer);
        disp('Finished Playing');
    end
    %----------------------------------------------------------------------
    % Database Info
    if choices==4
        clc;
        close all;
        if (exist('sound_database.dat')==2)
            sel = menu('Select an Option','Display Information','Play Selected Signal');       
            if sel==1
                load('sound_database.dat','-mat');
                message=strcat('Database has #',num2str(sound_number),'Voice Samples');
                disp(message);
                disp(' ');
              for ii=1:sound_number
                message=strcat('File & Location:',data{ii,4});
                disp(message);
                message=strcat('Duration of Signal:',num2str(data{ii,3}));
                disp(message);
                message=strcat('Sound ID:',num2str(data{ii,2}));
                disp(message);
                disp('-');
              end            
            end
            if sel==2
                load('sound_database.dat','-mat');
                message=strcat('Database has # ',num2str(sound_number),'Voice Samples');
                disp(message);
                disp(' ');
                sound_id=input('Enter the Speaker_ID you want to play:');
                soundsc(data{sound_id,1},Fs,Bits_no);
                disp('Playing...');               
                pause(data{sound_id,3}+2);
                disp('Playing Done!')
            end
        else
            warndlg('Database is empty.Go to Choice No.1',' Warning ')
        end
    end
    %----------------------------------------------------------------------
    % Delete database
    if choices==5
        clc;
        close all;
        if (exist('sound_database.dat')==2)
            sel = menu('Select an option','Complete Database','Selected One');
            if sel==1
                button = questdlg('Confirm Deleting Database?');
                if strcmp(button,'Yes')
                     delete('sound_database.dat');
                     msgbox('Database was succesfully removed from the current directory.','Database removed','help');
                else
                     msgbox('Database is not removed. User pressed No or Cancel','Database not Deleted','help');
                end            
            end              
           if sel==2
             load('sound_database.dat','-mat');
             if (size(data,1)>1)
                 msg=strcat('There are #',num2str(sound_number),'Database signals');
                 disp(msg);
                 opt=input('Enter the database signal you want to delete(enter>0&&<= No. of Database signals):');
                 [mn np]=size(opt);
             if (mn==1 && np==1 && opt<=size(data,1)&& opt~=0 && opt>0)
                 data(opt,:)=[];
                 sound_number=sound_number-1;                 
                 for ii=1:sound_number
                     data{ii,2}=ii;                                    
                 end
                 save('sound_database.dat','data','sound_number','Fs','Bits_no');
                 msgbox('Selected database signal is removed','Database removed','help');
             else                    
                 errordlg('Database signal has not removed.Incorrect data is Entered');
             end                                               
             else
                 errordlg('There is only 1 signal in database. Select option COMPLETE DATABASE to delete.');
             end                                               
         end
        else
          
            warndlg('Database is empty.',' Warning ');
        end               
    end
end
