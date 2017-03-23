function plotRect(corners,plotColor)
figure(1)
hold on
plot([corners(1,1) corners(1,2)],[corners(2,1) corners(2,2)],plotColor);
plot([corners(2,1) corners(2,2)],[corners(3,1) corners(3,2)],plotColor);
plot([corners(3,1) corners(3,2)],[corners(4,1) corners(4,2)],plotColor);
plot([corners(4,1) corners(4,2)],[corners(1,1) corners(1,2)],plotColor);