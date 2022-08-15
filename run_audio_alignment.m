recon_path = "/mnt/sdata_new/mri_data/disc/speech/vol0351_20220519/recon/";
%recon_path = "/server/home/pkumar/mri_data/jasa_el/ua"

%% Data loading and error out if mis-match.
audio_recon_path = fullfile(recon_path, "audio");
image_recon_path = fullfile(recon_path);

audio_ref_files = dir(fullfile(audio_recon_path, "/", "MAIN_*_pre_ref.wav"));
audio_files = dir(fullfile(audio_recon_path, "/", "DSP_OUT_*.wav"));
image_files = dir(fullfile(image_recon_path, ...
    "*.avi"));

if size(audio_files, 1) ~= size(image_files, 1)
   error("Make sure the # of files in the image directory and audio directory match!")
end

try
	[audio_sort_idx, image_sort_idx] = sort_audio_and_image_by_timestamp(audio_ref_files, image_files);
catch
	warning("the files are not named in a way that can be sorted. using default MATLAB sorting")
	audio_sort_idx = 1:length(audio_files);
	image_sort_idx = audio_sort_idx;
end



%% Audio Alignment step:
% Loop through pairs of files and run alignment.
for idx = 1:length(audio_sort_idx) %1:length(audio_sort_idx)

    audio_ref_object = audio_ref_files(audio_sort_idx(idx));
    audio_object = audio_files(audio_sort_idx(idx));
    image_object = image_files(image_sort_idx(idx));

    audio_ref_path = fullfile(audio_ref_object.folder, audio_ref_object.name);
    image_path = fullfile(image_object.folder, image_object.name);
    audio_path = fullfile(audio_object.folder, audio_object.name);

    try
        % extract 2 important features from the filename. TRToTrim and TempRes.
        tres_str = regexp(image_path, "tRes(.*)_GIRF", "match", "once");
        tempRes = str2num( regexprep( tres_str, {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) ) * 1e-3;

        trtotrim_str = regexp(image_path, "TRTrim(.*).avi", "match", "once")
        TRtoTrim = str2num( regexprep( trtotrim_str, {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) );

        n_arm_recon_str = regexp(image_path, "recon_narms(.*)_", "match", "once");
        n_arm_recon = str2num( regexprep( n_arm_recon_str, {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) );
        n_arm_recon = n_arm_recon(1)
    catch
        % If we cannot extract, use defaults.
        TrToTrim=150;
        tempRes=10.04 * 1e-3;
    end


    audio_write_path = fullfile(recon_path, 'audio_trunc/', ...
        [image_object.name(1:end-4), '_audio.wav']);

    image_write_path = fullfile(recon_path, 'video_with_audio', ...
        [image_object.name(1:end-4), '_with_audio.avi']);

    % dbstop audio_align
    audio_align(audio_ref_path, audio_path, image_path, audio_write_path, image_write_path, TRtoTrim, tempRes, n_arm_recon)
end
