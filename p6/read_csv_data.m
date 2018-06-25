function [stereoASoho, stereoBSoho, stereoAstereoB] = read_csv_data(filename)
	a = 0;
	b = 0;
	c = 0;
	
	stereoASoho = zeros(4, 2);
	stereoBSoho = zeros(4, 2);
	stereoAstereoB = zeros(4, 2);

	fid = fopen(filename);
	tline = fgetl(fid);
	while ischar(tline)
		tokens = strsplit(tline, ',');
		for j = 1 : length(tokens)
			s = tokens{j};
			s(s=='"') = [];
			tokens{j} = strtrim(s);
		end
	
		% 1-2 "Times for ->"    ,"STEREO-B/SOHO ",    
		if ~isempty(tokens{1})
			a = a +1;
			stereoBSoho(a, 1) = datenum(datetime(tokens{1},'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z'));
			stereoBSoho(a, 2) = to_num(textscan(tokens{2}, '%fRs'));
		end
		
		% 3-4 "Times for ->"    ,"STEREO-B/STEREO-A ",
		if ~isempty(tokens{3})
			b = b + 1;
			stereoAstereoB(b, 1) = datenum(datetime(tokens{3},'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z'));
			stereoAstereoB(b, 2) = to_num(textscan(tokens{4}, '%fRs'));
		end
		
		% 5-6 "Times for ->"    ,"SOHO/STEREO-A "
		if ~isempty(tokens{5})
			c = c + 1;
			stereoASoho(c, 1)= datenum(datetime(tokens{5},'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z'));
			stereoASoho(c, 2) = to_num(textscan(tokens{6}, '%fRs'));
		end
		
		tline = fgetl(fid);
	end

	fclose(fid);
end
