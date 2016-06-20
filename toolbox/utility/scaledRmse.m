function [rmse, coef]=scaledRmse(vec1, vec2)

coef=dot(vec1, vec2)/sum(vec1.^2);
diffVec=vec1*coef-vec2;
rmse=sqrt(sum(diffVec.^2)/length(diffVec));