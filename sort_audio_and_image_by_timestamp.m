function [audio_sort_idx, image_sort_idx] = sort_audio_and_image_by_timestamp(audio_files, image_files)
%   sort_audio_and_image_by_timestamp(audio_files, image_files)
%   finds a mapping between directory of
%   audio files from the optoacoustics system to data reconstructed by YL
%   bart code for new speech data.
%
%   audio files: list of audio files by name (MAIN_pre_ref files for
%   alignment.)
%   image files: list of image files by name

%% Construct the timestamp array for each file and sort.
%  We will use the order to combine.
audio_timestamps = zeros(length(audio_files), 1);
image_timestamps = zeros(length(image_files), 1);

for idx = 1:size(image_files, 1)   
    image_timestamp = str2double(image_files(idx).name(19:24));
    image_timestamps(idx) = image_timestamp;
end

for idx = 1:size(audio_files, 1)
    audio_timestamp = str2double(erase(audio_files(idx).name(17:24), ';'));
    audio_timestamps(idx) = audio_timestamp;
end
    
[~, audio_sort_idx] = sort(audio_timestamps);
[~, image_sort_idx] = sort(image_timestamps);

end
