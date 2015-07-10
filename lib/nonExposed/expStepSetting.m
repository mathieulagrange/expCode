function stepSetting = expStepSetting(vSpec, mask, currentStep)

vSet = expSettingSet(vSpec, mask, currentStep);

maskFilter = expMaskFilter(vSpec, vSet);
maskFilter.maskFilter = sum(vSet, 2)~=0;
% settings = expSettingBuild(vSpec, vSet);

if isempty(vSet)
    sequence = [];
else
    sequence = expSettingSequence(vSpec, vSet);
end

stepSetting.nbSettings = size(vSet, 2);
stepSetting.maskFilter = maskFilter;
stepSetting.sequence = sequence;
stepSetting.set = vSet;
stepSetting.specifications = vSpec;
stepSetting.id = currentStep;

if ~isempty(vSet)
    e=[];
    list={};
    for k=1:size(vSet, 1)
        for m=1:size(vSet, 2)
            if vSet(k, m)
                list{k, m} = vSpec.stringValues{k}{vSet(k, m)};
            else
                list{k, m} = '';
            end
        end
        if ~all(cellfun(@isempty,list(k, :)))
            e(end+1) = k;
        end
        values{k} = unique(list(k, :), 'stable');
        values{k}(cellfun(@isempty,values{k}))=[];
    end
    
    factors.list = list(e, :)';
    factors.names = vSpec.names(e);
    factors.values = values(e);
    %      factors.list = list';
    %     factors.names = vSpec.names;
    %     factors.values = values;
    
    stepSetting.factors = factors;
    stepSetting.setting = expSetting(stepSetting, 1);
end







