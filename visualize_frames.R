library('ggplot2')

dat <- read.csv("~/code/excitation_automaton/sd.csv");
nframes <- 
xmin <- min(dat$x);
xmax <- max(dat$x);
ymin <- min(dat$y);
ymax <- max(dat$y);
extremum <- max(abs(c(xmin, xmax, ymin, ymax)));
limit <- ceiling(extremum * 10) / 10.0

ggplot(dat) + geom_point(aes(x=x, y=y, color=frame)) + xlim(-limit, limit) + ylim(-limit, limit);
ggsave("~/code/excitation_automaton/trace.png");

for(i in frames) {
  ggplot(dat[dat$frame == i,]) + geom_point(aes(x=x, y=y, color=frame)) + xlim(-limit, limit) + ylim(-limit, limit) + theme(legend.position = "none");
  ggsave(sprintf("~/code/excitation_automaton/tmp/frame_%04d.png", i));
}
