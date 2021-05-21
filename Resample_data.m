function fname_resample = Resample_data(fname_data_target_Before_Resampling,fs,f_record)

if (fs ~= f_record)
P = 0 ;
Q = 0;
fname_resample = [];
[P,Q] = rat(fs /f_record);
fname_resample = resample(fname_data_target_Before_Resampling,P,Q);
else
fname_resample = fname_data_target_Before_Resampling;
end

end

