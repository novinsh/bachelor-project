%% env setup
clear all; clc; close all;
addpath(genpath(pwd));

%% load map
map = build_map('map2.osm', 'Observations5');
