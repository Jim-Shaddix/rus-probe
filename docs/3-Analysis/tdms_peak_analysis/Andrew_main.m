%% Store Crap
file1 = 'C:\Users\Cepheid\Documents\GitHub\rus-probe\docs\2-Files_To_Analyze\31 May 18 TaV2\';
% file2 = 
tdms_data = Store_TDMS_Data(file1);

%% Fitting stuff
perform_fit = true;
if perform_fit == true
    
    peaks = "mag_given_peaks";
    %peaks = "mag_set_peaks";
    %peaks = "mag_given_peaks";

    % PERFORM: fit
    fit_data = Lorentz_Fit_File(           ...
                    {tdms_data.frequency}, ...
                    {tdms_data.signal_x},  ...
                    {tdms_data.signal_y},  ...
                    {tdms_data.(peaks)},   ...
                     peak_width);

    % SET: fit_data
    for i = 1:length(fit_data)
        for j = 1:length(tdms_data(i).(peaks))
            [tdms_data(i).(peaks)(j).fit] = fit_data{i}(j);
        end
    end

    disp("Finished: Performing Fit")
    clear peaks perform_fit 
    
end

%% Plot shit
i = 7;
x = tdms_data(i).signal_x;
y = tdms_data(i).signal_y;
freq = tdms_data(i).frequency./1000;

hold on;
plot(freq, x)
plot(freq, y)

name = tdms_data(i).file_name(14:length(tdms_data(i).file_name)-5);
l = legend(name);
set(l,'Interpreter', 'none');
