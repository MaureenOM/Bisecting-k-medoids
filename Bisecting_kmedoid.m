function [clustInd,clustCent]=Bisecting_kmedoid(data,k)
%Similar to bisecting k-means but instead of using average point as
%centroid use member of the cluster as centroid. 

%Written by: Maureen Murage


%Algorithm:
% 1. Start with all data in one cluster
% 2. Bisect the cluster into two clusters
% 3. Bisect each cluster then find the bisection that results in minimized
% SSE and replace this cluster with the two new clusters formed from
% bisecting
% 4. Repeat step 3 till you have k clusters

[ind,cent,sumd]=kmedoids(data,1);

NoClust=1;

while NoClust<k
    lowest_sumd=inf;
    totalLength=1:NoClust;
    for i=1:NoClust
        datapoints4clust=data(ind==i,:);
        sz=size(datapoints4clust);
        if sz(1)>2
            [indsplt,centsplt,sumdsplt]=kmedoids(datapoints4clust,2);
            
            if NoClust>1
                sumd_withoutClusti=sumd(totalLength~=i);
                sumTotalSSE=sum(sumdsplt)+sum(sumd_withoutClusti);
            else
                sumTotalSSE=sum(sumdsplt);
            end
        
            if sumTotalSSE<lowest_sumd
                lowest_sumd=sumTotalSSE;
                bestClust2split=i;
                bestClustAss=indsplt;
                bestClustCent=centsplt;
                bestsumD=sumdsplt;
            end
        end
    end
    bestClustAss(bestClustAss==2)=NoClust+1;
    bestClustAss(bestClustAss==1)=bestClust2split;
    ind(ind==bestClust2split)=bestClustAss;
    cent(bestClust2split,:)=bestClustCent(1,:);
    cent(NoClust+1,:)=bestClustCent(2,:);
    sumd(bestClust2split)=bestsumD(1);
    sumd(NoClust+1)=bestsumD(2);
    fprintf('best clust to split is %1.0f\n',bestClust2split)
    fprintf('total SSE is %.1f\n',sum(sumd))
    
    
    NoClust=NoClust+1;
end

clustInd=ind;
clustCent=cent;
end
        