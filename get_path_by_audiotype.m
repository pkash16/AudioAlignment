function [main_path, ref_path, denoised_path, sorting_fn] = get_path_by_audiotype(type)
    %% Get path of main files, reference files, or noise-canceled files.
    %  type="OptoAcoustics"
    %           - main_path: "MAIN_*_pre.wav"
    %           - ref_path: "MAIN_*_pre_ref.wav"
    %           - denoised_path: "DSP_OUT_*.wav"
    %           - sorting_fn: given audio_reference_file_path, locate the
    %           timestamp for sorting  of files. If none exists, use the
    %           NaN function @(x) = NaN to do no sorting.
    %
    % If you want to add types, you must add file selections here.
    % ex: audio files are labeled 'audio' and no noise reduction exists.
    % we can just use the main audio as the denoised audio.
    %  if type =="CustomNoDenoise"
    %       main_path = "audio_*.wav"
    %       ref_path = "ref_*.wav"
    %       denoised_path = "audio_*_.wav"
    %       sorting_fun = @(ref_path) NaN
    %  end
    %
    % ex: no reference audio exists. we just use the same audio file for
    % everything.
    %  if type=="SingleFile"
    %        main_path = "audio_*.wav";
    %        ref_path = "audio_*.wav";
    %        denoised_path = "audio_*_.wav";
    %        sorting_fn = @(ref_path) NaN;
    %  end
    
    if type == "OptoAcoustics"
       main_path = "MAIN_*_pre.wav";
       ref_path = "MAIN_*_pre_ref.wav";
       denoised_path = "DSP_OUT_*.wav";
       sorting_fn = @(audio_ref_path) audio_ref_path(str2double(erase(audio_ref_path(17:24), ';')));
    end
    
    % Add custom handlers here if necessary.
    

end