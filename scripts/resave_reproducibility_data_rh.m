% Goal of this script is to resave each relevant quantity into a linear vector
load('mona_reproducibility_rh.mat');

group_list = [];
category_list = [];
subject_list = [];
value_list = [];

data_table = t1;

n_sighted_video = sum(strcmp(data_table.group, 'sv'));
n_sighted_audio = sum(strcmp(data_table.group, 'sa'));
n_blind = sum(strcmp(data_table.group, 'b'));

blind_indices = n_sighted_video+1:(n_sighted_video + 1 + n_blind);
sighted_audio_indices = 1:n_sighted_audio;
sighted_video_indices = 1:n_sighted_video;

subject_vector = [blind_indices, sighted_audio_indices, sighted_video_indices];
group_indices = struct('b', 1, 'sa', 2, 'sv', 3);

n_rows = size(data_table.cat, 1);
for row = 1:n_rows
	data = data_table.cat(row, :);
	group = data_table.group(row);
	group_index = group_indices.(group{1});
	subject_index = subject_vector(row);

	for category_index = 1:4
		category_value = data(category_index);

		% append IVs
		group_list = [group_list; group_index];
		category_list = [category_list; category_index];
		subject_list = [subject_list; subject_index];

		% append DV
		value_list = [value_list; category_value];
	end
end

%% Plot various colorings of the data points
figure('Position', [300, 300, 800, 300]);
set(gcf, 'Color', 'w');
marker_size = 30;

subplot(1, 3, 1);
scatter(...
	subject_list,...
	value_list,...
	marker_size,...
	categorical(subject_list),...
	'filled', 'MarkerEdgeColor', 'k'...
);
title('Colored by Unique Subject');
ylabel('RDM Diagonal');
xlabel('Subject ID');

subplot(1, 3, 2);
scatter(...
	subject_list,...
	value_list,...
	marker_size,...
	categorical(group_list),...
	'filled', 'MarkerEdgeColor', 'k'...
);
title('Colored by Group');
xlabel('Subject ID');

subplot(1, 3, 3);
scatter(subject_list,...
	value_list,...
	marker_size,...
	categorical(category_list),...
	'filled', 'MarkerEdgeColor', 'k'...
);
title('Colored by Category');
xlabel('Subject ID');

%% save to csv
data = [group_list, category_list, subject_list, value_list];
csvwrite('clean_data_rh.csv', data);
