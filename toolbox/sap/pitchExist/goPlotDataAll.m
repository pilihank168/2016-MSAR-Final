% 2D/3D scatter plots for data visualization

addMyPath;
load DS.mat

% ====== Compute the data amount for each class (�p��C�@�����O����ƶq)
figure; dsClassSize(DS, 1);
% ====== Plot class info w.r.t. a single feature (�i�����O��S�x���@��)
figure; dsProjPlot1(DS);
% ====== Project the data into 2D spaces (�N��Ƨ�v��G�תŶ�)
figure; dsProjPlot2(DS); set(gcf, 'name', 'Original Data');
% ====== Project the data into 3D spaces (�N��Ƨ�v��T�תŶ�)
figure; dsProjPlot3(DS); set(gcf, 'name', 'Original Data');

% ====== Feature-wise normalization to have zero-mean unity-variance (��C�@�ӯS�x�i�楿�W�ơA�Ϩ䦨��mu=0, sigma=1�������K�פ��G)
DS.input=inputNormalize(DS.input);
% ====== Project the normalized data into 2D spaces (�N��Ƨ�v��G�תŶ�)
figure; dsProjPlot2(DS); set(gcf, 'name', 'Normalized Data');
% ====== Project the normalized data into 3D spaces (�N��Ƨ�v��T�תŶ�)
figure; dsProjPlot3(DS); set(gcf, 'name', 'Normalized Data');