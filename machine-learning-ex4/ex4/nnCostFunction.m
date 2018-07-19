function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
cost = 0;
n= size(X,1);
X = [ones(n, 1) X];

a2 = sigmoid(X*Theta1');
a2 = [ones(n,1) a2];
a3 = sigmoid(a2*Theta2');
hx = a3;

y_exp = zeros(n, num_labels);
for i = 1 : n
    y_exp(i, y(i)) = 1;
end

for j = 1 : n  
    for k = 1 : num_labels            
        cost = cost - y_exp(j, k) * log(hx(j, k)) - (1 - y_exp(j, k)) * log(1 - hx(j, k));
    end
end
J = cost / n;

% -------------------------------------------------------------

 D1 = zeros(size(Theta1, 1), size(Theta1, 2));
 D2 = zeros(size(Theta2, 1), size(Theta2, 2));

 for t = 1 : n
        a1 = X(t, :);
        d3 = a3(t, :) - y_exp(t, :);
        d2 = (Theta2' * d3') .* a2(t, :)' .* (1 - a2(t, :)');
        D2 = D2 + d3' * a2(t, :);
        D1 = D1 + d2(2:end) * a1;
end

	cT1 =Theta1;
    
    cT1(:, 1)= 0;
    
    cT2 = Theta2;
    cT2(:, 1) = 0;

    D2 = (D2 + lambda * cT2) / n;
    D1 = (D1 + lambda * cT1) / n;

	grad = [D1(:) ; D2(:)];

% =========================================================================

	 regularization = lambda / 2 / n * ( sum(sum(Theta1(:, 2:end) .^ 2)) + sum(sum(Theta2(:, 2:end) .^ 2)));

J = J + regularization;


end
