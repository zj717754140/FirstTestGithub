
tracker='KCF';
colorModel='GRAY';
rtPath = 'depth';

seqset{1}='bag1';
seqset{2}='basketball1';
seqset{3}='basketball2';
seqset{4}='basketball2.2';
seqset{5}='basketballnew';
seqset{6}='bdog_occ2';
seqset{7}='bear_back';
seqset{8}='bear_change';
seqset{9}='bird1.1_no';
seqset{10}='bird3.1_no';
seqset{11}='book_move1';
seqset{12}='book_turn';
seqset{13}='book_turn2';
seqset{14}='box_no_occ';
seqset{15}='br_occ1';
seqset{16}='br_occ_0';
seqset{17}='br_occ_turn0';
seqset{18}='cafe_occ1';
seqset{19}='cc_occ1';
seqset{20}='cf_difficult';
seqset{21}='cf_no_occ';
seqset{22}='cf_occ2';
seqset{23}='cf_occ3';
seqset{24}='child_no2';
seqset{25}='computerBar2';
seqset{26}='computerbar1';
seqset{27}='cup_book';
seqset{28}='dog_no_1';
seqset{29}='dog_occ_2';
seqset{30}='dog_occ_3';
seqset{31}='express1_occ';
seqset{32}='express2_occ';
seqset{33}='express3_static_occ';
seqset{34}='face_move1';
seqset{35}='face_occ2';
seqset{36}='face_occ3';
seqset{37}='face_turn2';
seqset{38}='flower_red_occ';
seqset{39}='gre_book';
seqset{40}='hand_no_occ';
seqset{41}='hand_occ';
seqset{42}='library2.1_occ';
seqset{43}='library2.2_occ';
seqset{44}='mouse_no1';
seqset{45}='new_ex_no_occ';
seqset{46}='new_ex_occ1';
seqset{47}='new_ex_occ2';
seqset{48}='new_ex_occ3';
seqset{49}='new_ex_occ5_long';
seqset{50}='new_ex_occ6';
seqset{51}='new_ex_occ7.1';
seqset{52}='new_student_center1';
seqset{53}='new_student_center2';
seqset{54}='new_student_center3';
seqset{55}='new_student_center4';
seqset{56}='new_student_center_no_occ';
seqset{57}='new_ye_no_occ';
seqset{58}='new_ye_occ';
seqset{59}='one_book_move';
seqset{60}='rose1.2';
seqset{61}='static_sign1';
seqset{62}='studentcenter2.1';
seqset{63}='studentcenter3.1';
seqset{64}='studentcenter3.2';
seqset{65}='three_people';
seqset{66}='toy_car_no';
seqset{67}='toy_car_occ';
seqset{68}='toy_green_occ';
seqset{69}='toy_mo_occ';
seqset{70}='toy_no';
seqset{71}='toy_no_occ';
seqset{72}='toy_wg_no_occ';
seqset{73}='toy_wg_occ';
seqset{74}='toy_wg_occ1';
seqset{75}='toy_yellow_no';
seqset{76}='tracking4';
seqset{77}='tracking7.1';
seqset{78}='two_book';
seqset{79}='two_dog_occ1';
seqset{80}='two_people_1.1';
seqset{81}='two_people_1.2';
seqset{82}='two_people_1.3';
seqset{83}='walking_no_occ';
seqset{84}='walking_occ1';
seqset{85}='walking_occ_long';
seqset{86}='wdog_no1';
seqset{87}='wdog_occ3';
seqset{88}='wr_no';
seqset{89}='wr_no1';
seqset{90}='wr_occ2';
seqset{91}='wuguiTwo_no';
seqset{92}='zball_no1';
seqset{93}='zball_no2';
seqset{94}='zball_no3';
seqset{95}='zballpat_no1';

outdir=['result/' rtPath '/']
if ~exist(outdir,'dir')
    mkdir(outdir);
end

for i=1:95
    fprintf('processing %d\n',i);
   
    rtfile=['result/' colorModel '/' seqset{i} '_' tracker '_' colorModel '.txt'];
    
    rt=dlmread(rtfile);
    [M,N]=size(rt);
    rt_out=zeros(M,5);
    rt_out(:,1)=rt(:,1);
    rt_out(:,2)=rt(:,2);
    rt_out(:,3)=rt(:,1)+rt(:,3);
    rt_out(:,4)=rt(:,2)+rt(:,4);
    out_file = [outdir '/' seqset{i} '.txt'];
    fid = fopen(out_file,'wt+');
    for j=1:M
        fprintf(fid,'%.4f,%.4f,%.4f,%.4f,%d\n',rt_out(j,1),rt_out(j,2),rt_out(j,3),rt_out(j,4),rt_out(j,5));
    end
    fclose(fid);
end
