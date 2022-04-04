recon_path = "/Users/prakashkumar/Documents/PhD/mri_data/speech/vol0238_20220308/";

%% Data loading and error out if mis-match.
audio_recon_path = fullfile(recon_path, "audio");
image_recon_path = fullfile(recon_path, "recon");

audio_ref_files = dir(fullfile(audio_recon_path, "/", "MAIN_*_pre_ref.wav"));
audio_files = dir(fullfile(audio_recon_path, "/", "DSP_OUT_*.wav"));
image_files = dir(fullfile(image_recon_path, ...
    "*.avi"));

if size(image_files, 1) ~= size(image_files, 1)
   error("Make sure the # of files in the image directory and audio directory match!") 
end

[audio_sort_idx, image_sort_idx] = pair_speech_audio_to_image_files(audio_ref_files, image_files);


%% Audio Alignment step:
% Loop through pairs of files and run alignment.
for idx = 1:size(audio_sort_idx,1)
    
    audio_ref_object = audio_ref_files(audio_sort_idx(idx));
    audio_object = audio_files(audio_sort_idx(idx));
    image_object = image_files(image_sort_idx(idx));
    
    audio_ref_path = fullfile(audio_ref_object.folder, audio_ref_object.name);
    image_path = fullfile(image_object.folder, image_object.name);
    audio_path = fullfile(audio_object.folder, audio_object.name);
    
    audio_write_path = fullfile(recon_path, 'audio_trunc/', ...
        [image_object.name(1:end-4), '_audio.wav']);
    
    image_write_path = fullfile(recon_path, 'video_with_audio', ...
        [image_object.name(1:end-4), '_with_audio.avi']);
    
    audio_align(audio_ref_path, audio_path, image_path, audio_write_path, image_write_path)
end