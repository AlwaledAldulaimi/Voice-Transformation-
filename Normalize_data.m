function fname_data_target = Normalize_data(fname_data)

% Normalization
    % Zero Mean 
    fname_data_target =[];
    x_mean = 0;
    x_mean = (1/length(fname_data)) * sum(fname_data);
    fname_data_target = fname_data - x_mean;


    
end

