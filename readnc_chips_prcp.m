%%%read nc file chips precipitation

info = ncinfo('data(jan).nc');
prc = ncread('data(jan).nc','prcp');
