function fit = Lorentz_Fit(cell_x_cor_fit, cell_y_cor_fit, cell_guess)
% This function fits a complex lorentzian function to all of the peaks 
% in a given dataset, returns the arrays of the fit parameters found, and
% coordinates associated with the applied fit function.
%
% PARAMETERS:
% cell_x_cor_fit: [Cell Array] each cell contains:
%                 The x-coordinates to perform the fit on.
%
% cell_y_cor_fit: [Cell Array] each cell contains:
%                 The y-coordinates to perform the fit on.
%
% cell_guess:     [Cell Array] each cell contains:
%                 An ititial guess for fit perameters
% RETURNS:
% 1. [cell]: each cell contains:
%            a struct describing the fit performed 

    % function handle for: [complex lorentzian]
    % x = [A, theta, gamma, f_0, offset]
    lorentz_fnc = @(x, x_cor_fit) x(1) .* exp(1i .* x(2)) ./ ...
                               (x_cor_fit(1,:) - x(4) + 1i .* x(3) + x(5));

    % optional parameters for fit function
    options = optimoptions(@lsqcurvefit,     ...
                            'Display','off', ...
                            'TolX', 1e-10,   ...
                            'TolFun', 1e-10, ...
                            'MaxFunctionEvaluations', 1000000, ...
                            'MaxIterations', 1000000);
    
    % instantiate struct to return                    
    %fit = cell(1,length(cell_x_cor_fit));
                        
    for i = 1:length(cell_x_cor_fit)
        
        % easier access to data
        x_cor_fit = cell_x_cor_fit{i};
        y_cor_fit = cell_y_cor_fit{i};
        guess     = cell_guess{i};
        
        % Perform Fit:
        %   xEst:     fit parameters (Array of Floats) 
        %   resnorm:  sum of the squared residuals (Float) 
        %   residual: (Array of Floats)
        %   exitFlag: [1] -> function converged 
        %             [2] -> change x < tolerance 
        %             [3] -> change residual < tolerance
        [Est, resnorm, residual, exitFlag] = lsqcurvefit(               ... 
                                                  lorentz_fnc, guess,   ...
                                                  x_cor_fit, y_cor_fit, ... 
                                                  [],[],options);
        % GET: Y-coordinates from fit
        fit_curve = lorentz_fnc(Est,x_cor_fit);

        % SET: fit signal
        fit(i).frequencies = x_cor_fit;
        fit(i).signal_x    = real(fit_curve);
        fit(i).signal_y    = imag(fit_curve);

        % SET: fit parameters
        fit(i).A      = Est(1);
        fit(i).theta  = Est(2);
        fit(i).gamma  = Est(3);
        fit(i).f_0    = Est(4);
        fit(i).offset = Est(5);

    end

end