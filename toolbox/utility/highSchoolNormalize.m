function normalized=highSchoolNormalize(schoolName)
% highSchoolNormalize: Normalize highschool name

normalized=schoolName;
if ~isempty(strfind(schoolName, '建國')), normalized='建國中學'; end
if ~isempty(strfind(schoolName, '金門')), normalized='金門高中'; end
if ~isempty(strfind(schoolName, '臺南一中')), normalized='台南一中'; end
if ~isempty(strfind(schoolName, '臺南女子高級中學')), normalized='台南女中'; end
if ~isempty(strfind(schoolName, '復旦')), normalized='復旦高中'; end
if ~isempty(strfind(schoolName, '師大附中')), normalized='師大附中'; end
if ~isempty(strfind(schoolName, '師範大學附屬高級中學')), normalized='師大附中'; end
if ~isempty(strfind(schoolName, '高雄高級中學')), normalized='高雄中學'; end
if ~isempty(strfind(schoolName, '高雄高中')), normalized='高雄中學'; end
if ~isempty(strfind(schoolName, '高雄女子高級中學')), normalized='高雄女中'; end
if ~isempty(strfind(schoolName, '高雄女中')), normalized='高雄女中'; end
if ~isempty(strfind(schoolName, '成功高中')), normalized='成功中學'; end
if ~isempty(strfind(schoolName, '明道')), normalized='明道高中'; end
if ~isempty(strfind(schoolName, '板橋高中')), normalized='板橋高中'; end
if ~isempty(strfind(schoolName, '第一女子高級中學')), normalized='北一女中'; end
if ~isempty(strfind(schoolName, '第一女中')), normalized='北一女中'; end
if ~isempty(strfind(schoolName, '臺中一中')), normalized='台中一中'; end
if ~isempty(strfind(schoolName, '臺中第一高級中學')), normalized='台中一中'; end
if ~isempty(strfind(schoolName, '臺中女子高級中學')), normalized='台中女中'; end
if ~isempty(strfind(schoolName, '武陵')), normalized='武陵高中'; end
if ~isempty(strfind(schoolName, '園區實驗')), normalized='實驗中學'; end
if ~isempty(strfind(schoolName, '薇閣高級中學')), normalized='薇閣高中'; end
if ~isempty(strfind(schoolName, '薇閣高中')), normalized='薇閣高中'; end
if ~isempty(strfind(schoolName, '中山女子高級中學')), normalized='中山女中'; end
if ~isempty(strfind(schoolName, '精誠高級中學')), normalized='精誠高中'; end
if ~isempty(strfind(schoolName, '宜蘭高級中學')), normalized='宜蘭高中'; end
if ~isempty(strfind(schoolName, '成淵高中')), normalized='成淵高中'; end
if ~isempty(strfind(schoolName, '衛道高級中學')), normalized='衛道高中'; end
if ~isempty(strfind(schoolName, '彰化高級中學')), normalized='彰化中學'; end
if ~isempty(strfind(schoolName, '彰化高中')), normalized='彰化中學'; end
if ~isempty(strfind(schoolName, '新竹高中')), normalized='新竹中學'; end
if ~isempty(strfind(schoolName, '新竹女子高級中學')), normalized='新竹女中'; end
if ~isempty(strfind(schoolName, '新竹女中')), normalized='新竹女中'; end
if ~isempty(strfind(schoolName, '東山高中')), normalized='東山高中'; end
if ~isempty(strfind(schoolName, '正心高中')), normalized='正心高中'; end
if ~isempty(strfind(schoolName, '宜蘭高中')), normalized='宜蘭高中'; end
if ~isempty(strfind(schoolName, '文生高中')), normalized='文生高中'; end
if ~isempty(strfind(schoolName, '鳳新高中')), normalized='鳳新高中'; end
if ~isempty(strfind(schoolName, '衛道高中')), normalized='衛道高中'; end
if ~isempty(strfind(schoolName, '文華高中')), normalized='文華高中'; end
return


if ~isempty(strfind(schoolName, '建國')), normalized='臺北市立建國高級中學'; end
if ~isempty(strfind(schoolName, '金門')), normalized='國立金門高級中學'; end
if ~isempty(strfind(schoolName, '高雄中學')), normalized='高雄市立高雄高級中學'; end
if ~isempty(strfind(schoolName, '台南一中')), normalized='國立臺南第一高級中學'; end
if ~isempty(strfind(schoolName, '臺南一中')), normalized='國立臺南第一高級中學'; end
if ~isempty(strfind(schoolName, '復旦')), normalized='桃園縣私立復旦高中'; end
if ~isempty(strfind(schoolName, '師大附中')), normalized='國立臺灣師範大學附屬高級中學'; end
if ~isempty(strfind(schoolName, '師範大學附屬高級中學')), normalized='國立臺灣師範大學附屬高級中學'; end
if ~isempty(strfind(schoolName, '成功高中')), normalized='臺北市立成功高級中學'; end
if ~isempty(strfind(schoolName, '明道')), normalized='私立明道高級中學'; end
if ~isempty(strfind(schoolName, '北一女中')), normalized='臺北市立第一女子高級中學'; end
if ~isempty(strfind(schoolName, '台中一中')), normalized='國立臺中第一高級中學'; end
if ~isempty(strfind(schoolName, '武陵')), normalized='國立武陵高級中學'; end
if ~isempty(strfind(schoolName, '園區實驗')), normalized='國立科學工業園區實驗高級中學'; end
if ~isempty(strfind(schoolName, '薇閣高級中學')), normalized='私立薇閣高級中學'; end
if ~isempty(strfind(schoolName, '中山女子高級中學')), normalized='台北市立中山女子高級中學'; end
if ~isempty(strfind(schoolName, '松山高中')), normalized='臺北市立松山高中'; end
if ~isempty(strfind(schoolName, '新竹女中')), normalized='國立新竹女子高級中學'; end
if ~isempty(strfind(schoolName, '延平中學')), normalized='私立延平高級中學'; end
if ~isempty(strfind(schoolName, '大同高中')), normalized='台北市立大同高級中學'; end
if ~isempty(strfind(schoolName, '第一女子高級中學')), normalized='臺北市立第一女子高級中學'; end
if ~isempty(strfind(schoolName, '嘉義高中')), normalized='國立嘉義高級中學'; end
if ~isempty(strfind(schoolName, '文華高中')), normalized='國立文華高級中學'; end
if ~isempty(strfind(schoolName, '衛道高中')), normalized='私立衛道高級中學'; end
if ~isempty(strfind(schoolName, '精誠高級中學')), normalized='私立精誠高中'; end
if ~isempty(strfind(schoolName, '衛道高中')), normalized='私立衛道高級中學'; end

return
	
switch(schoolName)
	case '建國'
		normalized='臺北市立建國高級中學';
	case '金門'
		normalized='國立金門高級中學';
	case '高雄'
		normalized='高雄市立高雄高級中學';
	case {'台南', '臺南'}
		normalized='國立臺南第一高級中學';
	case '復旦'
		normalized='桃園縣私立復旦高中'
	case {'師大附中', '師範大學附屬高級中學'}
		normalized='國立臺灣師範大學附屬高級中學';
	case '成功高中'
		normalized='臺北市立成功高級中學';
	case '明道'
		normalized='私立明道高級中學';
	case {'北一女中', '第一女子高級中學'}
		normalized='臺北市立第一女子高級中學';
	case '台中一中'
		normalized='國立臺中第一高級中學';
	case '武陵'
		normalized='國立武陵高級中學';
	case '園區實驗'
		normalized='國立科學工業園區實驗高級中學';
	case '薇閣'
		normalized='私立薇閣高級中學';
	case '中山'
		normalized='台北市立中山女子高級中學';
	case '松山高中'
		normalized='臺北市立松山高中';
	case '新竹女中'
		normalized='國立新竹女子高級中學';
	case '延平中學'
		normalized='私立延平高級中學';
	case '大同高中'
		normalized='台北市立大同高級中學';
	case '嘉義高中'
		normalized='國立嘉義高級中學';
	case '文華高中'
		normalized='國立文華高級中學';
	case '衛道高中'
		normalized='私立衛道高級中學';
	case '精誠高級中學'
		normalized='私立精誠高中';
	otherwise
		normalized=schoolName;
	%	fprintf('No normalization for %s\n', schoolName);
end
