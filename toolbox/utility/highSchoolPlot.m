function highSchoolPlot(schoolData)

[junk, index]=sort([schoolData.weight]);
schoolData=schoolData(index);

subplot(311); bar([schoolData.studentCount]); title('Student count');
subplot(312); bar([schoolData.mae]); title('MAE');
subplot(313); barPlot([schoolData.weight], {schoolData.school}); title('Weight');
h=findobj(gca, 'type', 'text'); set(h, 'fontsize', 12);