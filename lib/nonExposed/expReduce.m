function config=expReduce(config)

% TODO reduceData per expose Call

data = {};
reduceFileName = [config.obsPath config.stepName{config.step.id} filesep 'reduceData.mat'];

if exist(reduceFileName, 'file')
    % get vSet
    modReduce = dir(reduceFileName);
    modFactors = dir(config.factorFileName);
    loadedData=load(reduceFileName, 'vSet');
    if isequal(loadedData.vSet, config.step.set) && modReduce.datenum > modFactors.datenum
        loadedData=load(reduceFileName, 'data');
        data = loadedData.data;
    end
end

if isempty(data)
%     config.step.id = config.step.id+1; % FIX ME fragile
    
    config.loadFileInfo.date = {'', ''};
    config.loadFileInfo.dateNum = [Inf, 0];
    
    for k=1:config.step.nbSettings
        config.step.setting = expSetting(config.step, k);
        
        [~, ~, config] = expLoad(config, [], config.step.id, 'obs', [], 0);
        if ~isempty(config.load)
            data{k} = config.load;
        else
            data{k} = [];
        end
    end
    
    if config.loadFileInfo.dateNum(2)
        disp(['Loaded data files dates are in the range: | ' config.loadFileInfo.date{1} ' || ' config.loadFileInfo.date{2} ' |']);
        vSet = config.step.set; %#ok<NASGU>
        save(reduceFileName, 'data', 'vSet', 'config');
%             copyfile(reduceFileName, [config.reportPath config.experimentName '.mat']);
    end
%     config.step.id = config.step.id-1;
end

% list all observations
observations = {};
structObservations = {};
maxLength = 0;
for k=1:length(data)
    if ~isempty(data{k})
        names = fieldnames(data{k});
        for m=1:length(names)
            if isstruct(data{k}.(names{m})) % || iscell(data{k}.(names{m}))
                structObservations = [structObservations names{m}];
            elseif ~iscell(data{k}.(names{m}))
                observations = [observations names{m}];
            end
        end
        for m=1:length(names)
            maxLength = max(maxLength, length(data{k}.(names{m})));
        end
    end
end
observations = unique(observations);
structObservations = unique(structObservations);

% build results matrix
%results = zeros(length(data), length(observations), maxLength)*NaN;
% results = zeros(length(data), length(observations), maxLength)*NaN;
% for k=1:size(results, 2)
%     for m=1:size(results, 1)
%         if isfield(data{m}, observations{k}) && ~isempty((data{m}.(observations{k})))
%             results(m, k, (1:length(data{m}.(observations{k})))) = data{m}.(observations{k});
%         end
%     end
% end

if isempty(structObservations)
    structResults = [];
else
    for k=1:length(structObservations)
        n=1;
        for m=1:length(data)
            if isfield(data{m}, structObservations{k})
                structResults.(structObservations{k})(n) = data{m}.(structObservations{k});
                %             structResults.(structObservations{k})(n).setting = config.settings(m);
                n=n+1;
            end
        end
    end
end

% store
config.evaluation.observations = observations;
config.evaluation.results = data;
config.evaluation.structObservations = structObservations;
config.evaluation.structResults = structResults;
config.evaluation.data = data;
