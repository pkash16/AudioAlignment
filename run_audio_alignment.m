function [] = run_audio_alignment(recon_path, audio_type, image_type)
    %% Function to align files in a given reconstruction path.
    %  recon_path: filepath for reconstruction directory.
    %       - must contain a subfolder labeled "audio"
    %  audio_type: audio type refers to the way audio files are named.
    %       - ex: 'OptoAcoustics' uses this file format:
    %           - main mic audio: "MAIN_*_pre.wav"
    %           - reference audio: "MAIN_*_pre_ref.wav"
    %           - noise-cancelled audio: "DSP_OUT_*.wav"
    %       - custom strings can be added by implementing an if statement
    %       in get_path_by_audiotype()
    % image_type: image type refers to the way image files are named.
    %       - ex: "tres_trim_encoded": [timestamp]_tRes[tRes]_TRTrim[TRTrim].avi
    %       - custom strings can be added by implementing an if statement
    %       in get_path_by_imagetype()


    [main_path, ref_path, denoised_path, audio_sorting_fn] = get_path_by_audiotype(audio_type);
    [image_sorting_fn, image_temp_res_fn, image_trim_fn] = get_path_by_imagetype(image_type);

    %% Data loading and error out if mis-match.
    audio_recon_path = fullfile(recon_path, "audio");
    image_recon_path = fullfile(recon_path);

    audio_ref_files = dir(fullfile(audio_recon_path, "/", main_path));
    audio_files = dir(fullfile(audio_recon_path, "/", denoised_path));
    image_files = dir(fullfile(image_recon_path, ...
        "*.avi"));

    if size(audio_files, 1) ~= size(image_files, 1)
       error("Make sure the # of files in the image directory and audio directory match!")
    end

    try
        [audio_sort_idx, image_sort_idx] = sort_audio_and_image_by_timestamp(audio_ref_files, image_files, audio_sorting_fn, image_sorting_fn);
    catch
        warning("using default MATLAB sorting! This is caused by NaN in sorting_fns in get_path_by_audiotype or get_path_by_imagetype")
        audio_sort_idx = 1:length(audio_files);
        image_sort_idx = audio_sort_idx;
    end

    %% Audio Alignment step:
    % Loop through pairs of files and run alignment.
    for idx = 1:length(audio_sort_idx)

        audio_ref_object = audio_ref_files(audio_sort_idx(idx));
        audio_object = audio_files(audio_sort_idx(idx));
        image_object = image_files(image_sort_idx(idx));

        audio_ref_path = fullfile(audio_ref_object.folder, audio_ref_object.name);
        image_path = fullfile(image_object.folder, image_object.name);
        audio_path = fullfile(audio_object.folder, audio_object.name);

        try
            tempRes = image_temp_res_fn(image_object.name);
            TRtoTrim = image_trim_fn(image_object.name);

            if isnan(tempRes)
                warning('temporal resolution for trimming not specified. Using 200ms')
                tempRes = 200;
            elseif isnan(TRtoTrim)
                warning('TR to Trim is not specified. Using 0')
                TRtoTrim = 0;
            end
        catch e
            % If we cannot extract, use these defaults?
            error('unable to extract TR or temporal resolution from filename. Double check you get_path_by_imagetype() call');
        end

        % make folders if they don't exist.
        if ~exist(fullfile(recon_path, 'audio_trunc/'), 'dir')
            mkdir(fullfile(recon_path, 'audio_trunc/'));
        end
        if ~exist(fullfile(recon_path, 'video_with_audio/'), 'dir')
            mkdir(fullfile(recon_path, 'video_with_audio/'));
        end

        audio_write_path = fullfile(recon_path, 'audio_trunc/', ...
            [image_object.name(1:end-4), '_audio.wav']);

        image_write_path = fullfile(recon_path, 'video_with_audio', ...
            [image_object.name(1:end-4), '_with_audio.avi']);

        audio_align(audio_ref_path, audio_path, image_path, audio_write_path, image_write_path, TRtoTrim, tempRes)
    end
end
