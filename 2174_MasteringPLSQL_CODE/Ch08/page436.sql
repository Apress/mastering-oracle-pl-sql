conn system/manager
audit execute on scott.beta_package by access;

noaudit execute on scott.beta_package;
drop package scott.alpha_package;
drop package scott.beta_package;
drop user alpha;
drop user beta;
