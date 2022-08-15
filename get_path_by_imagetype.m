function [sorting_fn, temp_res_fn, trim_fn] = get_path_by_imagetype(type)
    %% Get sorting function for image types.
    % type: "tres_trim_encoded"
    %  filename has the format: [timestamp]_tRes[tRes]_TRTrim[TRTrim].avi
    %
    %  ex: 095918_tRes150_TRTrim4.avi
    %
    % type: "USC" for images named using USC data collection framework
    %  filename has the format usc_disc_[date]_[time]_*_TRTrim[TRTrim].avi
    %  with many additional parameters in the "*".
    %
    %  ex: usc_disc_20220729_095918_yl_speech_rt_ssfp_fov24_res24_n13_
    %    vieworder_bitr_raw_recon_narms02_13_sl06mm_nframes1203_lt0.080_
    %    ls0.000_lw0.000_FOV240mm_sRes2.31_tRes10.06_GIRF_acq_delay-6.0_
    %    demcor_TRTrim0150.avi
    %
    % If you want to add types, you must add custom handlers to this file.
    %
    %
    % OUTPUTS:
    % sorting_fn: given image path, locate the
    %           timestamp for sorting  of files
    % temp_res_fn: given image path, locate the
    %           temporal resolution in ms.
    % trim_fn: given image path, locate the
    %           amount of frames to trim from beginning of video.
    %  

    
    if nargin == 0
        type = "tres_trim_encoded";
    end
    
    
    if type == "USC"
       sorting_fn = @(image_path) image_path(str2double(erase(image_path(19:24), ';')));
       temp_res_fn = @(image_path) str2num( regexprep( regexp(image_path, "tRes(.*)_", "match", "once"), {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) ) * 1e-3;
       trim_fn = @(image_path) str2num( regexprep( regexp(image_path, "TRTrim(.*).avi", "match", "once"), {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) );
    elseif type == "tres_trim_encoded"
        sorting_fn = @(image_path) image_path(1:7);
        temp_res_fn = @(image_path) str2num( regexprep( regexp(image_path, "tRes(.*)_", "match", "once"), {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) ) * 1e-3;
        trim_fn = @(image_path) str2num( regexprep( regexp(image_path, "TRTrim(.*).avi", "match", "once"), {'\D*([\d\.]+\d)[^\d]*', '[^\d\.]*'}, {'$1 ', ' '} ) );
    else
        % Add custom handlers here if necessary instead of catchall 'else'.
       sorting_fn = @(image_path) NaN;
       temp_res_fn = @(image_path) 200; % 200 ms per frame.
       trim_fn = @(image_path) 0; % no trimming of image file necessary.
    end
    

    

end