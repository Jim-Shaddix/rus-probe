function plot_struct = Get_Plot_Struct()
%GET_PLOT_STRUCT: This struct contains all of the possible options for
% analyzing a single file, and creating a single plot.  
%
% Information In This Struct Contained:
% 1. Functions to preprocess the data 
% 2. The initial fit parameters used
% 3. The initial parameters used for finding peaks
% 4. What information will be displayed for a single plot
% 5. The color of the plot lines, and other plot information

    %% Preprocess %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % cell array of function pointers.
    % - all these functions get applied to the raw data, prior to making any
    %   plots
    plot_struct.preprocess = {};

    %% PLOTTING RAW / PEAK / FIT Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % determines whether or not to plot the raw data, magnitude data,
    % or you can set both.
    plot_struct.raw = 0;
    plot_struct.mag = 0;
    
    % Peaks / Fits
    % Three word parameters (that describe the field):
    % 1. peaks
    % 2. raw/mag:       (What type of data to plot the peak/fit)
    % 3. set/given: (Where the peak/fit comes.)
    % First  number (0,1) denotes whether or not the peaks should be plotted
    % Second number (0,1) denotes whether or not the fit   should be plotted
    plot_struct.peaks_raw  = [0,0];
    plot_struct.peaks_mag  = [0,0];
    plot_struct.peaks_tracked = 0;
    
    %% PEAKS
    % Parameters: for Track_Peaks_Interval
    plot_struct.track_interval = 15000;
    plot_struct.track_freq = 881200;
    
    % Default Parameters: for findpeaks        [RANGE]
    find_peak_opts.MinPeakHeight     = 0;      % > 0
    find_peak_opts.MinPeakProminence = 0.0001; % > 0
    find_peak_opts.Threshold         = 0;      % > 0
    find_peak_opts.MinPeakDistance   = 20000;  % > 0
    find_peak_opts.MinPeakWidth      = 0;      % > 0
    find_peak_opts.MaxPeakWidth      = Inf;    % > 0
    find_peak_opts.WidthReference    = 'halfprom';
    
    plot_struct.peak_options        = find_peak_opts;
        
    %% FITTING
    % Default Optimization Parameters: for lsqcurvefit
        
    options = optimoptions(@lsqcurvefit,     ...
                            'Display','off', ...
                            'TolX', 1e-10,   ...
                            'TolFun', 1e-10, ...
                            'MaxFunctionEvaluations', 1000000, ...
                            'MaxIterations', 1000000, ...
                            'Algorithm','levenberg-marquardt');
                        
    plot_struct.fit_options = options;
    
    % The width of the peaks are extracted by peakfind
    % - this number is multiplied to the widths of the peaks,
    %   and the number returned will be the interval I use
    %   for fitting a peak.
    plot_struct.fit_width_multiplier = 1;
    
    % if this value is set to 1, the hard-coded width will be used instead
    % of the fit_width_multiplier
    plot_struct.hard_coded_width = 0;
    
    % hard coded width
    plot_struct.fit_width = 0.01*10^6;
    
    % Functions for determing interval-width
    plot_struct.fit_interval_raw = @(width_half_prom) width_half_prom;
    plot_struct.fit_interval_mag = @(width) 4*width;
    
    %% Plotting Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % These are parameters that are used for displaying information in
    % plots.
    
    % Displays: Plot Peak Widths
    plot_struct.plot_width = 0;
    
    % axis limits (generally each of these fields will hold two values, a
    % minimum and maximum value associated with the axis to plot.
    % but I will let them hold a zero when I am not concerned with saving
    % this information) (see Plot_File.m for how they get used)
    % In short: if a zero is stored, than when plot_file is called, 
    % matlab will use pick its own axis limits. If there is an array of
    % two values stored, than plot_file will use those values as the axis
    % limits when using plot_file. 
    % This is used in the GUI, for the hold axis button.
    plot_struct.XLim = 0;
    plot_struct.YLim = 0;
    
    % determines wether or not to set the ticks on the plot for
    % both the x and the y axis
    plot_struct.remove_ticks = 0;
    
    % Determines whether or not to plot numbers next to the 
    % magnitude peaks
    plot_struct.mag_labels = 0;
    
    % ----- Legend Labels -----
    plot_struct.legend = 0;
    
    % data
    plot_struct.x_label   = {"signal-x"};           
    plot_struct.y_label   = {"signal-y"};
    plot_struct.mag_label = {"magnitude"};
    
    % peaks
    plot_struct.x_peak_label   = {"signal-x peak"}; 
    plot_struct.y_peak_label   = {"signal-y peak"};
    plot_struct.mag_peak_label = {"magnitude peak"};
    
    % fits
    plot_struct.x_fit_label   = {"signal-x fit"};   
    plot_struct.y_fit_label   = {"signal-y fit"};
    plot_struct.mag_fit_label = {"magnitude fit"};
    % -------------------------
    
    % ----- Configure Line Colors -----
       
    % data
    plot_struct.x_param   = {'r-'};
    plot_struct.y_param   = {'b-'};
    plot_struct.mag_param = {'g-'};
    
    % fits
    plot_struct.fit_x_param    = {'y', 'LineWidth',4,'HandleVisibility','on'};
    plot_struct.fit_y_param    = {'c', 'LineWidth',4,'HandleVisibility','on'};
    plot_struct.fit_mag_param  = {'m', 'LineWidth',4,'HandleVisibility','on'};
    
    % peaks
    plot_struct.peak_x_param   = {'r*','HandleVisibility','on'};
    plot_struct.peak_y_param   = {'b*','HandleVisibility','on'};
    plot_struct.peak_mag_param = {'m*','HandleVisibility','on'};
    
    plot_struct.peak_tracked_param = {'m*','HandleVisibility','off'};

    % ----- Axis Labels -----
    % - axis labels can be determined statically.
    % - titles have to be determined dynamically though.
    project_config = Get_Project_Struct();
    plot_struct.xlabel = project_config.file_x_axis_measurment;
    plot_struct.ylabel = project_config.file_y_axis_measurment;
    plot_struct.get_title  = @(tdms_data) tdms_data.id;
    
    %% GUI Parameters
    
    % significant coordinates along the x-axis.
    % you may want to store x-coordinates associated
    % with phase transistions in this variable.
    % this variable is refferenced in peak_analyzer
    % for plotting vertical lines that correspond
    % to x-coordinates that are stored in this
    % variable.
    plot_struct.sig_x_coordinates = []; 
end

