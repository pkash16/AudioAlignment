function audio_align(audio_ref_path, audio_path, image_path, audio_write_path, video_write_path)
%   audio_align(audio_path, image_path, video_write_path)
%   Takes one audio file and one image file and then does the alignment
%   between the two and outputs to video file in video_write_path.
%   
%   audio_path: audio filepath (.wav)
%   image_path: image filepath (.avi)
%   video_write_path: video filepath (.avi)

%% Data loading
[audio_ref_data, sampling_f] = audioread(audio_ref_path);
[audio_data, sampling_f] = audioread(audio_path);

alignment_thresh = max(audio_ref_data) / 2; % Alignment Threshold to determine when scanner is "on"

%% Find begin and end for alignment.

% Super Naive Implementation Attempt
% Find the first time above thresh, call it "begin" and same for "end".
threshold_idxs = find(abs(audio_ref_data) > alignment_thresh);

if isempty(threshold_idxs)
    warning('audio file is invalid!')
    warning(['audio_path: ' audio_path])
    warning(['image_path: ' image_path])
    return;
end

begin_idx = threshold_idxs(1);
end_idx = threshold_idxs(end) + 1;

if begin_idx == 1 || abs(size(audio_ref_data, 1)) < 1
    %Not worth aligning. throw out.
    warning('audio data invalid. remember to turn on audio recording before scan!');
    return;
end

end_idx = min(end_idx, size(audio_ref_data,1));

truncated_audio = audio_data(begin_idx:end_idx);
audiowrite(audio_write_path, truncated_audio, sampling_f);

system(strjoin(['ffmpeg -i ', image_path, ' -i ', audio_write_path, ...
        ' -c:a copy ', video_write_path]));

end