f1=imread('58.bmp');
f1=f1(70:730,206:818);
sum_row=sum(f1,2);
[pks,loc]=findpeaks(sum_row);
[sp,ind1]=sort(pks,'descend');
loc1=loc(ind1(1));
loc2=loc(ind1(2));
w=fspecial('average',3);
fa=imfilter(f1,w,'replicate');
fa=fa(min(loc1,loc2)-10:max(loc1,loc2)+10,:);
T=graythresh(fa);
g=im2bw(fa,T);
g1=edge(g,'sobel','horizontal');
g2=imdilate(g1,ones(3,3));
[L,num]=bwlabel(g2);
len=zeros(num,1);
for i=1:num
    idx{i}=find(L==i);
    len(i)=length(idx{i});
end
[sl,id1]=sort(len,'descend');
len_av=mean(len);
is_large=sl>=mean(len);
id1_large=id1.*is_large;
g3=zeros(size(g2));
idx1=cell(sum(is_large),1);
for i=1:length(id1_large)
    if id1_large(i)>0
        g3(idx{id1(i)})=1; 
        idx1{i}=idx{id1(i)};
    end
end
idx2=cell(sum(is_large),1);
for i=1:sum(is_large)
    [I,J]=ind2sub(size(g2),idx1{i});
    idx2{i}=[I,J];
    if max(J)-min(J)<0.8*size(g2,2)
        idx2{i}=[];
    end
end
count=1;
for i=1:sum(is_large)
    if ~isequal(idx2{i},[])
        idx3{count}=sub2ind(size(g2),idx2{i}(:,1),idx2{i}(:,2));
        count=count+1;
    end
end
g4=zeros(size(g3));
loc=zeros(length(idx3),1);
for i=1:length(idx3)
    g4(idx3{i})=1;
    [I,J]=ind2sub(size(g2),idx3{i});
    idx3{i}=[I,J];
    loc(i)=mean(I);
    idx3{i}=sub2ind(size(g2),idx3{i}(:,1),idx3{i}(:,2));
end
[sloc,id2]=sort(loc);
sloc_d=diff(sloc);
[m,id3]=max(sloc_d);
g5=zeros(size(g4));
g5(idx3{id2(id3)})=1;
g5(idx3{id2(id3+1)})=1;
g6=bwmorph(g5,'thin',inf);
[L1,num1]=bwlabel(g6);
[I1,J1]=find(L1==1);
[I2,J2]=find(L1==2);
m1=mean(I1);
m2=mean(I2);
g7=zeros(size(g6));
id4=sub2ind(size(g6),I1,J1);
g7(id4)=1;
g8=zeros(size(g7));
id5=sub2ind(size(g6),I2,J2);
g8(id5)=1;
g9=zeros(size(g6));
g10=g9;
if m1<m2
    for i=1:size(g7,2)
        col_vec_1=g7(:,i);
        m_1=max(col_vec_1);
        if m_1==1
            id5=find(col_vec_1==1);
            g9(min(id5),i)=1;
        end
        col_vec_2=g8(:,i);
        m_2=max(col_vec_2);
        if m_2==1
            id6=find(col_vec_2==1);
            g10(max(id6),i)=1;
        end
    end
else 
    for i=1:size(g8,2)
        col_vec_1=g8(:,i);
        m_1=max(col_vec_1);
        if m_1==1
            id5=find(col_vec_1==1);
            g9(min(id5),i)=1;
        end
        col_vec_2=g7(:,i);
        m_2=max(col_vec_2);
        if m_2==1
            id6=find(col_vec_2==1);
            g10(max(id6),i)=1;
        end
    end
end
g11=g9 | g10;
f2=zeros(size(f1));    
f3=f2;
f2(min(loc1,loc2)-10:max(loc1,loc2)+10,:)=g9;
f3(min(loc1,loc2)-10:max(loc1,loc2)+10,:)=g10;
[r1,c1]=find(f2==1);
[r2,c2]=find(f3==1);
imshow(f1);
hold on
plot(c1,r1,'r');
plot(c2,r2,'r');
        
    