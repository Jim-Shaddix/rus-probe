function all_peak_info = Get_Peaks(mag_boolean, cell_frequency, cell_signal_x, cell_signal_y, peak_opts)
% sets the peaks to be plotted: using [peakfind] for both
%
% PARAMETERS:
% 1. mag_boolean: [boolean] if true,  fit is performed on the magnitude data
%                        if false, fit is performed on the raw data
% 2. cell_freuqency: [Cell] each cell contains all the frequncies
%                           associated with a particular file
% 3/4. cell_signal_x/y: [Cell] each cell contains all the signal data
%                           associated with a particular file
% 4. peak_opts: [struct] containing the options used for performing the fit
%
% RETURNS:
% 1. [cells of structs] -> each struct describing the peak found

    % SET: optional parameters for fit function
    if nargin < 5
        peak_opts.MinPeakDistance   = 100;
        peak_opts.MinPeakProminence = 0.0001;
    end

    % INITIALIZE: return value
    all_peak_info = cell(1,length(cell_frequency));
    
    % SET: return struct fields
    for i = 1:length(all_peak_info)
        
        % easier access to data
        freq     = cell_frequency{i};
        signal_x = cell_signal_x{i};
        signal_y = cell_signal_y{i};
        
        mag = Magnitude(signal_x, signal_y);
 
        % GET: peak info
        if mag_boolean == true
            [peak_signal, peak_freq, peak_width] = findpeaks(mag, freq, peak_opts);
            % skip rest iteration if no peaks found
            if isempty(peak_signal)
                continue
            end
        else
            [xpeak_signal, xpeak_freq, xpeak_width] = findpeaks(signal_x, freq, peak_opts);
            [ypeak_signal, ypeak_freq, ypeak_width] = findpeaks(signal_y, freq, peak_opts);
            % skip rest iteration if no peaks found
            if isempty(xpeak_signal) && isempty(ypeak_signal) 
                continue
            end

        end
                
        % SET: peak info
        if mag_boolean
            
            set_peaks(length(peak_signal)) = struct();
            
            for j = 1:length(peak_signal) 
                
                % SET: basic info
                set_peaks(j).signal      = peak_signal(j);
                set_peaks(j).Frequencies = peak_freq(j);
                set_peaks(j).width       = peak_width(j);

                % index in the frequency list, where the peak occured
                index = find(freq == set_peaks(j).Frequencies, 1);

                % SET: y-coordinates
                set_peaks(j).signal_x = signal_x(index);
                set_peaks(j).signal_y = signal_y(index);
                set_peaks(j).mag      = mag(index);
                
            end
            
        else
            
            set_peaks(max(length(xpeak_signal),length(ypeak_signal))) = struct();
            
            for j = 1:length(xpeak_signal)
                
                % SET: basic info
                set_peaks(j).x_signal      = xpeak_signal(j);
                set_peaks(j).x_frequencies = xpeak_freq(j);
                set_peaks(j).x_width       = xpeak_width(j);
                
            end
            
            for j = 1:length(ypeak_signal)
                
                % SET: basic info
                set_peaks(j).y_signal      = ypeak_signal(j);
                set_peaks(j).y_frequencies = ypeak_freq(j);
                set_peaks(j).y_width       = ypeak_width(j);
                
            end
            
        end
        
        all_peak_info{i} = set_peaks;
        clear set_peaks

    end
    
end
