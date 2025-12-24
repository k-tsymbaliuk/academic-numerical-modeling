clear all;

w = 300;
r = 101;
z = 101;

schet = 0;
p = 10;

U1 = zeros(r, z);
U2 = zeros(r, z);

dr = 0.01;
dz = 0.01;

dt = (dr * dr) / (2 * 10);
k  = dt / (dr * dr);

% Boundary potential on lateral surface
lim = zeros(1, z);
for i = 2:(z - 1)
    lim(i) = w * (1 - (i - 0.5) * dr);
end
lim(1) = lim(2);
lim(z) = -lim(z - 1);

% Initialize boundary conditions
for i = 1:z
    U1(r - 1, i) = lim(i);
    U1(r, i)     = lim(i);
end

while p > 0.0001

    % Sweep in r-direction
    for i = 2:(z - 1)
        for j = 2:(r - 1)
            dUr  = (U1(j + 1, i) - U1(j - 1, i));
            d2Ur = (U1(j + 1, i) - 2 * U1(j, i) + U1(j - 1, i));
            dUz  = (U1(j, i + 1) - 2 * U1(j, i) + U1(j, i - 1));

            U2(j, i) = U1(j, i) + (k / (2 * (j - 0.5))) * dUr + k * d2Ur + k * dUz;
        end
    end

    % Boundary updates for U2
    for j = 1:r
        U2(j, 1) = U2(j, 2);
        U2(j, z) = -U2(j, z - 1);
    end
    for i = 1:z
        U2(r - 1, i) = lim(i);
        U2(r, i)     = lim(i);
        U2(1, i)     = U2(2, i);
    end

    % Sweep in z-direction
    for j = 2:(r - 1)
        for i = 2:(z - 1)
            dUr  = (U2(j + 1, i) - U2(j - 1, i));
            d2Ur = (U2(j + 1, i) - 2 * U2(j, i) + U2(j - 1, i));
            dUz  = (U2(j, i + 1) - 2 * U2(j, i) + U2(j, i - 1));

            U1(j, i) = U2(j, i) + (k / (2 * (j - 0.5))) * dUr + k * d2Ur + k * dUz;
        end
    end

    % Boundary updates for U1
    for j = 1:r
        U1(j, 1) = U1(j, 2);
    end
    for i = 1:z
        U1(r, i)     = lim(i);
        U1(r - 1, i) = lim(i);
        U1(1, i)     = U1(2, i);
    end
    for j = 1:r
        U1(j, 1) = U1(j, 2);
        U1(j, z) = -U1(j, z - 1);
    end

    % Convergence check
    schet = schet + 1;
    y = max(max(U1 - U2));
    p = sqrt(y^2);

    p
    schet
end

schet

contourf(U1, 10)
