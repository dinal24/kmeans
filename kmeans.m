% K-means Clustering with random randomly initiated heads
% The function takes a matrix, X, with one vector per row
% The function returns vectors of clusters and heads

function  [clusters, head]  = kmeans( X,num_clusters )
% This function does k-means clustering
% do several trails in case of local minima
num_trials = 10;

% Dimension of vectors, number of vectors
[num_vectors dim] = size(X);

clusters = ones(num_vectors,1);
thiscluster = clusters;  % to set the size of this temporary variable

bestcost = inf;  % look for the best clustering = min cost
head = zeros(num_clusters, dim);  % set the size of the matrix

for t = 1:num_trials  % try a few times in case of local minima

    previous_cost = inf;  %  keep looping until cost doesn't change

    %  Choose random cluster heads
    chosen = zeros(num_vectors,1); % to avoid duplicate heads
    for c = 1:num_clusters   %Chose random cluster heads
      r = randi(num_vectors);
      while chosen(r) == 1   % find a head not chosen before
        r = randi(num_vectors);
      end
      head(c,:) = X(r,:);
      chosen(r) = 1;
    end    % Choose Heads


    %  LOOP UNTIL CONVERGED (NO CHANGE IN COST)
    while true

    %assign each node to a cluster based on the closest head
    for i = 1:num_vectors
      min_c = 1;
      min_dist = distance(head(1,:), X(i,:));
      for c = 2:num_clusters
        d = distance(head(c,:), X(i,:));
        if(d<min_dist)
          min_dist = d;
          min_c = c;
        end
      end
      thiscluster(i) = min_c;
    end

    % Move the cluster head to the centroid
    % Take arithmetic mean of the elements of the cluster
    % to calculate centroid

    for c = 1:num_clusters
      list_c = find(thiscluster == c);
      head(c,:) = sum(X(list_c,:))/length(list_c);
    end;

    %calculate total cost to see if we have stopped converging
    cost = 0;
    for i = 1:num_vectors
      d = X(i,:) - head(thiscluster(i),:);
      cost = cost + d*d';
    end;

    if cost == previous_cost   % check if converged
      break
    else
      previous_cost = cost; %otherwise loop again
    end
   end

    if cost < bestcost   % remember the best clustering so far
        bestcost = cost;
        clusters = thiscluster;
    end
end


end

% distance function
function d = distance(x,y)
    % should be distance
    % symetric, triangle in equality
    % POSITIVE
    d = sqrt(sum((x-y).^2));
end