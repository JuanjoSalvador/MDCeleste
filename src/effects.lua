-- effects --
-------------

clouds = {}
for i=0,16 do
    add(clouds,{
        x=rnd(128),
        y=rnd(128),
        spd=1+rnd(4),
        w=32+rnd(32)
    })
end

particles = {}
for i=0,24 do
    add(particles,{
        x=rnd(128),
        y=rnd(128),
        s=0+flr(rnd(5)/4),
        spd=0.25+rnd(5),
        off=rnd(1),
        c=6+flr(0.5+rnd(1))
    })
end

dead_particles = {}