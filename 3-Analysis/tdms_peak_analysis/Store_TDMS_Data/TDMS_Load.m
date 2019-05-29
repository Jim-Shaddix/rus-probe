function tdms_data=TDMS_Load(path_to_files)
% 1. Reads directory (path_to_files) for filenames and 
%    loads all TDMS files into Cell Array. 
% 2. Extracts Temperature and Magnetic fields from filenames.
%    See the next section for a more thourogh description of how this is
%    done.
% 3. extracts signal_x, and signal_y data from the tdms files.
%
% PARAMETERS:
% 1. path_to_files (char arrary): describes the path to search for tdms
%    files

    % Store File Information ----------------------------------------------

    project_config = Get_Project_Struct();
    
    % UPDATE path_to_files
    % - this is done to accomodate the TDMS_getStruct function, that
    %   requires that the directory passed in ends with /.
    path_to_files = char(path_to_files);
    if path_to_files(end) ~= '/'
        path_to_files(end+1) = '/';
    end

    % GET: structure that descibes the provided path
    dir_struct = dir(path_to_files);
    
    % CHECK: if a faulty directory was passed in
    % refferences to the current and previous directory will always be
    % found, so if no files or directiories are found, than a faulty path
    % was used.
    if isempty(dir_struct)
        error(['No files were found in the directory specified!', ...
               ' This may be the result of a non-existent directory being specified.']);
    end
    
    % GET: file names ending with .tdms
    file_names      = string({dir_struct.name});
    tdms_file_names = file_names(endsWith(file_names,'.tdms'));
    
    % CHECK: [For if a .tdms file was found]
    if isempty(tdms_file_names)
        fprintf('No tdms Files Were Found in the directory passed in:\n')
        fprintf([char(path_to_files),'\n\n'])
        fprintf('These are the files/directories that were found:\n');
        disp(file_names');
        error('Failed to find tdms files in the provided path !!!');
    end
  
    %% INIT struct
    
    % these vatiables are used in the next section for parsing file names
    units        = project_config.map_measurement_unit.values;
    measurements = project_config.map_measurement_unit.keys;
    
    % Creates the struct template that I will be storing all 
    % of the info from the tdms files into.
    tdms_data = Get_RUS_Data_Struct(measurements);
    tdms_data(2:length(tdms_file_names)) = tdms_data(1);
    
    % store all of the tdms file names into our struct
    cell_tdms_file_names =  num2cell(tdms_file_names);
    [tdms_data.file_name] = cell_tdms_file_names{:};
    
    %% PARSE: Independent Variable Values From File Names
    %
    %   The value of independent variables are stored in the file names.
    %   (For RUS-probe experiments, that typically means temperature and
    %   and magnetic field values.) This section of the code will parse
    %   out those values from the filenames.
    %   * Values are parsed out using regular expressions.
    %     * All fields with values of with indpendent variable values
    %       I am interested in processing are sepperated by underscores.
    %
    %     EXAMPLE FILE NAMES:
    %     * For the units T and oe, valid file names are displayed below.
    %
    %     * x:   represents some character)
    %     * ...: used to denote that any number of characters are valid.)
    %     * (f: repsents some floating point number)
    %     
    %     1. xxx ... _fT_  ... xxx.tdms
    %     2. xxx ... _foe_ ... xxx.tdms
    %     3. xxx ... _fT_  ... _foe_ ... xxx.tdms
    %     4. xxx ... _foe_ ... _fT_  ... xxx.tdms
    
    function stripped_value = strip_value(unit2match, file_name)
    % Strips out a value associated with a filename
    % filename: character array to strip from.
    % unit2match: my program will strip out values associated with the units 
    %             passed in.
        matches = regexp(file_name,['_[+-]?\d*\.?\d*',unit2match,'_'], 'match');
        if isempty(matches)
           stripped_value = 0;
        else
           stripped_value = matches{end}(2:end-(length(unit2match)+1));
           stripped_value = str2double(stripped_value);
        end

    end
    
    % store data in tdms_data
    % - loop over the different units, and parse the values from each
    %   file name, associated with the units passed in.
    for i=1:length(units)
        
        % values associated with each unit
        unit_values = cellfun(@(f) strip_value(units{i},f), ...
                              cell_tdms_file_names);
        
        cell_unit_values = num2cell(unit_values);
        
        [tdms_data.(measurements{i})] = cell_unit_values{:};
    end
    
    % Creating ID's
    for i=1:length(tdms_data)
        for j=1:length(units)
            tdms_data(i).id = [tdms_data(i).id, ...
                               num2str(tdms_data(i).(measurements{j})), ...
                               units{j}];
            if j ~= length(units)
                tdms_data(i).id = [tdms_data(i).id,' - '];
            end
        end
    end
    
    %% read in data
    for i=1:length(tdms_file_names)
        % Store Signal Information ----------------------------------------
        
        % Prints Information as it is being read in
        fprintf('Reading In: File-Number = %i \t file_name = %s\n',i,tdms_file_names{i})
        
        % STORE: uses a package found online for reading tdms files, to
        % store all of the data from the tdms file into a struct
        RUSdata = TDMS_getStruct([path_to_files,tdms_file_names{i}]);

        % GET/STORE: Temperature From File Name Using Regex
        %pattern = '\d{0,3}\.?\d+K';
        %temperature_str = erase(regexp(tdms_file_names{i}, pattern, 'match'), 'K');
        %tdms_data(i).temperature     = str2double(temperature_str);

        % STORE: Plot Data
        % Eliminates leading 0 in data set if needed.
        % In particular, I throw out the first 4 values if a zero was
        % found, just in case something was going wrong.
        % This is bad practice as I am throughinh out some data points,
        % but it is a temporary fix.
        if RUSdata.p.Signal_X.data(1) == 0 || RUSdata.p.Signal_Y.data(1) == 0
            tdms_data(i).signal_x        = RUSdata.p.Signal_X.data(5:length(RUSdata.p.Signal_X.data));
            tdms_data(i).signal_y        = RUSdata.p.Signal_Y.data(5:length(RUSdata.p.Signal_Y.data));
            tdms_data(i).frequency       = RUSdata.p.Frequency.data(5:length(RUSdata.p.Frequency.data));
        else
            tdms_data(i).signal_x        = RUSdata.p.Signal_X.data;
            tdms_data(i).signal_y        = RUSdata.p.Signal_Y.data;
            tdms_data(i).frequency       = RUSdata.p.Frequency.data;
        end

        % CHECK: if peaks were found in the tdms file
        if ~isfield(RUSdata,'fit')
            continue
        end

    end
    
    [tdms_data.plot_info] = deal(Get_Plot_Struct());

    % * Assign titles to plots
    %   - because plot titles need to be dynamically determined, I have
    %     waited until I have read in all of the data to store this value
    for i=1:length(tdms_data)
       tdms_data(i).plot_info.title = tdms_data(i).plot_info.get_title(tdms_data(i)); 
    end
    
    % Sort struct
    %tdms_data = sortStruct(tdms_data,'temperature',-1);
    
end


