clear all; clc;
addpath(genpath('/Users/eshed/projects/rosenke_blind'));

hemis = {'lh', 'rh', 'both'};
types = {'Kendall', 'Pearson', 'Spearman'};

subplot_idx = 1;
for hemi_idx = 1:length(hemis)
	hemi = hemis{hemi_idx};

	blind_data = load_data('blind', 'audio', 'VTCn', hemi);
	sighted_video_data = load_data('sighted', 'video', 'VTCn', hemi);
	sighted_audio_data = load_data('sighted', 'audio', 'VTCn', hemi);

	all_data = [blind_data, sighted_video_data, sighted_audio_data];

	for type_idx = 1:length(types)
		subplot(3, 3, subplot_idx);
		type = types{type_idx};

		subject_to_subject_sim = corr(all_data, 'Type', type);
		imagesc(subject_to_subject_sim);
		title(sprintf('%s: %s', hemi, type));
		subplot_idx = subplot_idx + 1;
	end

end
