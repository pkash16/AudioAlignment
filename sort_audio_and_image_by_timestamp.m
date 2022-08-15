function [audio_sort_idx, image_sort_idx] = sort_audio_and_image_by_timestamp(audio_files, image_files, audio_sorting_fn, image_sorting_fn)
%   sort_audio_and_image_by_timestamp(audio_files, image_files)
%   finds a mapping between directory of
%   audio files from the audio system to image reconstruction files based
%   on timestamps.
%
%   audio files: list of audio files by name (MAIN_pre_ref files for
%   alignment.)
%   image files: list of image files by name
%   audio_sorting_fn: function given audio file_path to extract timestamp.
%   image_sorting_fn: function given image file_path to extract timestamp. 

%% Construct the timestamp array for each file and sort.
%  We will use the order to combine.
audio_timestamps = zeros(length(audio_files), 1);
image_timestamps = zeros(length(image_files), 1);

for idx = 1:size(image_files, 1)
    image_timestamp = str2double(image_files(idx).name(19:24));
    image_timestamps(idx) = image_timestamp;
end

for idx = 1:size(audio_files, 1)
    audio_timestamp = audio_sorting_fn(audio_files(idx).name);
    audio_timestamps(idx) = audio_timestamp;
end
    
[~, audio_sort_idx] = sort(audio_timestamps);
[~, image_sort_idx] = sort(image_timestamps);

end
