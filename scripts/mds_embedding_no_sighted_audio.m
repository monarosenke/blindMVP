clear all; clc;
addpath(genpath('/Users/eshed/projects/rosenke_blind'));

hemis = {'lh', 'rh', 'both'};

for hemi_idx = 1:length(hemis)
	hemi = hemis{hemi_idx};
	subplot(1, 3, hemi_idx);

	blind_data = load_data('blind', 'audio', 'VTCn', hemi);
	sighted_video_data = load_data('sighted', 'video', 'VTCn', hemi);

	% first test, MDS embedding of everything
	all_data = [blind_data, sighted_video_data];
	labels = repelem(...
		[{'Blind'}, {'Sighted Video'}],...
		[size(blind_data, 2), size(sighted_video_data, 2)]...
	)';

	number_labels = [1:size(blind_data, 2), 1:size(sighted_video_data, 2)];


	subject_to_subject_sim = corrcoef(all_data);
	subject_to_subject_dissim = 1 - subject_to_subject_sim;

	[embedding, stress] = mdscale(subject_to_subject_dissim, 2);

	% plot embedding
	gscatter(embedding(:, 1), embedding(:, 2), labels);
	for nli = 1:length(number_labels)
		text(...
			embedding(nli, 1),...
			embedding(nli, 2),...
			sprintf('%d', number_labels(nli)),...
			'FontSize', 18 ...
		);
	end
	title(hemi);
end
