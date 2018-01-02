function [peaks_vals,peaks_idx_final]=findpeaks_sigvalid(signal,options)
%Find local maxima points (neigbourhood - 1 sample to each direction)
%Implemented by for loop (not MATLAB friendly). Discard first and last samples

% options.PeakProminence - (scalar) minimal prominence of peaks from at least one side
% for a peak at index max_idx there must be samples ii of signal to the left or to the right of max_idx
% such that signal(max_idx)>=signal(ii)+options.PeakProminence

slength=length(signal);
peaks_idx_raw=[];
peaks_idx_final=[];

if slength<3
    error('signal input is too short');
end

peaks_idx_raw=zeros(length(signal),1);
count=0;
%Take only indices that are local maxima (maximal value among adjacent samples)
for k=2:1:(slength-1)
    if (signal(k)> signal(k-1) &  signal(k)> signal(k+1))  | (signal(k)> signal(k-1)& (signal(k))>= signal(k+1))
        count=count+1;
        peaks_idx_raw(count,1)=k;
    end
end

if count==0
     peaks_idx_raw=[];
     
else
    peaks_idx_raw=peaks_idx_raw(1:count);
end
%%%DEBUG only
%  plot(idx,signal,'-b',peaks_idx_raw,signal(peaks_idx_raw),'sr')


%Among maxima idx, take only maxima for which there exist signal samples that are
%  at least

if  exist('options') & isfield(options,'PeakProminence')
    len_numofpeaks=length(peaks_idx_raw);
    peaks_idx_raw_logical=repmat(logical(0),len_numofpeaks,1);
    
    for tt=1:1:len_numofpeaks
        cur_peak_idx=peaks_idx_raw(tt);
        cur_peak_val=signal(cur_peak_idx);
        
        if tt==1
            suuround_left_idx=1;
        else
            suuround_left_idx=peaks_idx_raw(tt-1);
        end
        
        if tt==len_numofpeaks
            suuround_right_idx=length(signal);
        else
            suuround_right_idx=peaks_idx_raw(tt+1);
        end
        
        min_in_surround=min(signal(  suuround_left_idx: suuround_right_idx));
        
        if   (min_in_surround+options.PeakProminence<= cur_peak_val)
            peaks_idx_raw_logical(tt)=logical(1);
        end
        
    end
    peaks_idx_final= peaks_idx_raw(peaks_idx_raw_logical);
    peaks_vals=signal(peaks_idx_final);
    
else  %no prominence criterion
    peaks_idx_final= peaks_idx_raw;
    peaks_vals=signal(peaks_idx_final);
end

end


