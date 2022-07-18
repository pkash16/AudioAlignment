function [audio_final_idxs, image_final_idxs] = pair_speech_audio_to_image_files_v2(audio_files, image_files)
%   pair_speech_audio_to_image_files(audio_files, image_files)
%   finds a mapping between directory of
%   audio files from the optoacoustics system to data reconstructed by YL
%   bart code for new speech data.
%
%   audio files: list of audio files by name (MAIN_pre_ref files for
%   alignment.)
%   image files: list of image files by name

audio_final_idxs = [];
image_final_idxs = [];

image_errors = [];
audio_errors = [];

[audio_sort_idx, image_sort_idx] = sort_audio_and_image_by_timestamp(audio_files, image_files);
audio_files = audio_files(audio_sort_idx);
image_files = image_files(image_sort_idx);

num_files = min(length(image_files), length(audio_files));

audio_idx_counter = 1;
image_idx_counter = 1;
while (image_idx_counter <= num_files) && (audio_idx_counter <= num_files)
    audio_timestamp = erase(audio_files(audio_idx_counter).name(17:24), ';');
    image_timestamp = image_files(image_idx_counter).name(19:24);

    audio_start = datetime(audio_timestamp, 'InputFormat', 'HHmmss');
    image_start = datetime(image_timestamp, 'Inputformat', 'HHmmss');

    % manual correction between the RThawk computer and the audio computer
    % system times. This was measured using 'date'.
    image_start = image_start + seconds(52);

    % read the files to get the "end of acq" time.
    [y, Fs] = audioread(fullfile(audio_files(audio_idx_counter).folder, ...
        audio_files(audio_idx_counter).name));
    audio_len = length(y) * (1/Fs);
    
    image_info = aviinfo(fullfile(image_files(audio_idx_counter).folder, ...
        image_files(audio_idx_counter).name));
    image_len = image_info.NumFrames * (1 / image_info.FramesPerSecond);
    
    audio_end = audio_start + seconds(audio_len);
    image_end = image_start + seconds(image_len);
    
    % give +/- 1 second leeway for alignments to be "successful". fixes
    % more errors than it causes.
    cond1 = (image_start >= audio_start) || (image_start >= audio_start + seconds(1)) || (image_start >= audio_start - seconds(1));
    cond2 = (audio_end >= image_end) || (audio_end >= image_end - seconds(1)) ||  (audio_end >= image_end + seconds(1));
    
    if cond1 && cond2
       %great!
       audio_final_idxs = [audio_final_idxs audio_sort_idx(audio_idx_counter)];
       image_final_idxs = [image_final_idxs image_sort_idx(image_idx_counter)];
       audio_idx_counter = audio_idx_counter + 1;
       image_idx_counter = image_idx_counter + 1;
    elseif cond1 && ~cond2
        % we are missing the video.
        warning('MISSING VIDEO! SKIPPING');
        audio_files(audio_idx_counter)
        image_files(image_idx_counter)
        
        audio_errors = [audio_errors; audio_files(audio_idx_counter).name];
        audio_idx_counter = audio_idx_counter + 1;
    elseif cond2 && ~cond1
        warning('MISSING AUDIO! SKIPPING');
        audio_files(audio_idx_counter)
        image_files(image_idx_counter)
        
        image_errors = [image_errors; image_files(image_idx_counter).name];
        image_idx_counter = image_idx_counter + 1;
    else
        audio_files(audio_idx_counter)
        image_files(image_idx_counter)
        warning('something went seriously wrong with audio+video files above this message.');
        if audio_idx_counter < image_idx_counter
            audio_errors = [audio_errors; audio_files(audio_idx_counter).name];
            audio_idx_counter = audio_idx_counter + 1;
        else
            image_errors = [image_errors; image_files(image_idx_counter).name];
            image_idx_counter = image_idx_counter + 1;
        end
    end
    
end

save(fullfile(image_files(1).folder, 'pairing_errors.mat'), 'image_errors', 'audio_errors');

assert(length(audio_final_idxs) == length(image_final_idxs), "paired file lengths must match!");

end