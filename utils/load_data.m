function mean_rsm = load_data(group, modality, roi, hemi)
% LOAD_DATA
% Inputs
% 	group (str): one of 'blind' or 'sighted'
% 	modality (str): one of 'audio' or 'video'
% 	roi (str): only 'VTCn' supported for now
% 	hemi (str): 'lh', 'rh', or 'both'. If 'both', averages lh and rh data
% 	
% Notes 	
% 	this script always averages odd and even data for each subject 	

	% find the file path
	data_dir = '/Users/eshed/projects/rosenke_blind/data';
	fpath = sprintf('%s/RSM_oddEven_%s_%s_%s_hbd.mat',...
		data_dir,...
		roi,...
		modality,...
		group...
	);

	assert(exist(fpath, 'file') == 2, sprintf('%s is not a file', fpath));

	% load the files depending on group
	load_struct = load(fpath);
	switch(group)
		case 'sighted'
			even = load_struct.correlations_si_even;
			odd = load_struct.correlations_si_odd;
		case 'blind'
			even = load_struct.correlations_bl_even;
			odd = load_struct.correlations_bl_odd;
	end

	% average hemispheres and splits
	switch (hemi)	
		case 'lh'
			mean_rsm = mean(cat(3, even{1}, odd{1}), 3);
		case 'rh'
			mean_rsm = mean(cat(3, even{2}, odd{2}), 3);
		case 'both'
			mean_rsm = mean(cat(3, even{1}, even{2}, odd{1}, odd{2}), 3);
	end
end
