var express = require('express');
var mysql = require('./dbConfig.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});
var bodyParser = require('body-parser');

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 18858); // <–––––––––––––port 18859

app.use(bodyParser.urlencoded( {extended: false}));
app.use(bodyParser.json());
app.use(express.static('public'));
//app.use('/public', express.static(__dirname + '/public'));

var focusFilterID = 1;

/* render home page
--------------------------------------------------------------------------*/
// get info for all tables and populate the tables and forms
app.get('/',function(req,res,next){
  var context = {};

  var callback = function(rows) {console.log("this is the callback function for athSports");}
  var genQuery = "SELECT a. id, a.first_name, a.last_name, a.DOB, a.sex, a.fitness_level, " +
                        "f.focus_type, d.diet_name, d.diet_type, a.interests FROM athletes a " +
                  "INNER JOIN focus f ON a.athlete_focus = f.id " +
                  "INNER JOIN diet d ON a.athlete_diet = d.id";
  mysql.pool.query(genQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var athlist = [];
    var athCount = rows.length;
    // get each element to display in the table
    for(var ath in rows){
      var athlete = { 'id': rows[ath].id,
                      'name': rows[ath].last_name + ", " + rows[ath].first_name,
                      'DOB': rows[ath].DOB,
                      'sex': rows[ath].sex,
                      'fitness_level': rows[ath].fitness_level,
                      'focus_type': rows[ath].focus_type,
                      'diet_name': rows[ath].diet_name,
                      'diet_type': rows[ath].diet_type,
                      'interests': rows[ath].interests};
      var sportsQuery = "SELECT s.sport_name FROM athletes_sports a_s " +
                        "INNER JOIN sport s ON s.id = a_s.s_id " +
                        "WHERE a_s.a_id = " + rows[ath].id + ";";
      mysql.pool.query(sportsQuery, function(sp_err, sp_rows, sp_fields){
        if(err){
          next(err);
          return;
        }
        console.log(sp_rows);
        var sports = [];
        for(var sp in sp_rows){
          if (typeof variable !== 'undefined') {
            sports.push(rows[sp].sport_name);
          }
        }
        athlete.sports = sports;
        //context.athletes = athlist;
        if (0 === --athCount) {
          callback(rows)
        }
      }); //subQuery
      athlist.push(athlete);
    } //for (aths)
    context.athletes = athlist;
  }); //main query

  //get the diets
  var diets = "SELECT d.id, d.diet_name, d.diet_type, f.focus_type, d.description FROM diet d " +
              "INNER JOIN focus f ON d.diet_focus = f.id;";
  mysql.pool.query(diets, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var diets = [];
    for(var d in rows){
        var diet = { 'id': rows[d].id,
                      'diet_name': rows[d].diet_name,
                      'diet_type': rows[d].diet_type,
                      'dietFocus': rows[d].focus_type,
                      'description': rows[d].description};
        diets.push(diet);
    }
    context.diets = diets;
    console.log(context.diets);
  });

  //get sports and diet by focus
  var focusFilterID = 5;//req.focusFilterID; // from context.focusFilterID by the filter function
  var FilterSports = "SELECT s.sport_name FROM sport_focus sf " +
                     "INNER JOIN sport s ON s.id = sf.s_id " +
                     "WHERE sf.f_id = " + focusFilterID + ";";
  var FilterDiets = "SELECT diet_name, diet_type, description FROM diet " +
                    "WHERE diet_focus = " + focusFilterID + ";";
  /*SELECT s.sport_name, d.diet_name, d.diet_type, d.description FROM diet d
    INNER JOIN sport_focus sf ON sf.f_id = d.diet_focus
    INNER JOIN sport s ON s.id = sf.s_id
    WHERE d.diet_focus = ID # */ // <–– too many rows
  mysql.pool.query(FilterSports, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var focusFilterSports = [];
    // get each element we want to display in the table
    for(var f in rows){
        var focFilter = { 'sport_name': rows[f].sport_name};
        focusFilterSports.push(focFilter);
        console.log(focFilter);
    }
    //context.focusFilter = rows;
    context.focusFilterSports = focusFilterSports;
    console.log(context.focusFilterSports);
  });

  mysql.pool.query(FilterDiets, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var focusFilterDiets = [];
    // get each element we want to display in the table
    for(var f in rows){
        var focFilter = { 'diet_name': rows[f].diet_name,
                          'diet_type': rows[f].diet_type,
                          'description': rows[f].description};
        focusFilterDiets.push(focFilter);
        console.log(focFilter);
    }
    //context.focusFilter = rows;
    context.focusFilterDiets = focusFilterDiets;
    console.log(context.focusFilterDiets);
  });


  //get the foci
  var focuses = "SELECT *  FROM focus;";
  mysql.pool.query(focuses, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var foci = [];
    // get each element we want to display in the table
    for(var f in rows){
        var focus = { 'id': rows[f].id,
                      'focus_type': rows[f].focus_type};
        foci.push(focus);
    }
    context.foci = foci;
    console.log(context.foci);
  });

  //get the sports
  var sports = "SELECT *  FROM sport;";
  mysql.pool.query(sports, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var allSports = [];
    // get each element we want to display in the table
    for(var s in rows){
        var sport = { 'id': rows[s].id,
                      'sport_name': rows[s].sport_name};
        allSports.push(sport);
    }
    context.sports = allSports;
    console.log(context.sports);

    //Now that we have all the table info we need
    //Render the page!
    console.log("here comes the context...");
    console.log(context);
    res.render('home', context);
  });
  //this part is out of scope
});



/*EDIT ATHLETES TABLE
--------------------------------------------------------------------------*/
//add athlete
app.get('/insertAth',function(req,res,next){
  var context = {};
  var addAthQuery = "INSERT INTO athletes (first_name, last_name, DOB, sex, " +
                    "fitness_level, athlete_focus, athlete_diet, interests) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
  mysql.pool.query(addAthQuery, [req.query.first_name, req.query.last_name, req.query.dob,
                                 req.query.sex, req.query.fitness_level, req.query.athlete_focus,
                                 req.query.athlete_diet, req.query.interests], function(err, result){
    if(err){
      next(err);
      return;
    }
    //refresh the page
    res.redirect('back');
  });
});

//add sports
app.get('/add_athletes_sports', function(req,res,next){
  var context = {};
  var A_S_query = "INSERT INTO athletes_sports (a_id, s_id) VALUES (?, ?)";
  mysql.pool.query(A_S_query, [req.query.athletesID, req.query.athletesSports], function (err, result) {
    if(err) {
      next(err);
      return;
    }
    res.redirect('back');
  });
});

//aupdate athlete
app.get('/updateAth',function(req,res,next){
  var context = {};
  mysql.pool.query("SELECT * FROM athletes WHERE id=?", [req.query.athleteID], function(err, result){
    if(err){
      next(err);
      return;
    }
    if(result.length == 1){
      var curVals = result[0];
      mysql.pool.query("UPDATE athletes SET first_name=?, last_name=?, DOB=?, sex=?, " +
                       "fitness_level=?, athlete_focus=?, athlete_diet=?, interests=? WHERE id=? ",
                       [req.query.first_name || curVals.first_name, req.query.last_name || curVals.last_name,
                        req.query.dob || curVals.DOB, req.query.sex || curVals.sex,
                        req.query.fitness_level || curVals.fitness_level,
                        req.query.athlete_focus || curVals.athlete_focus,
                        req.query.athlete_diet || curVals.athlete_diet,
                        req.query.interests || curVals.interests,
                        req.query.athleteID], function(err, result){
        if(err){
          next(err);
          return;
        }
      });
      if (req.query.athleteSports != null) {
        mysql.pool.query("INSERT INTO athletes_sports (a_id, s_id) VALUES (?, ?) ",
          [req.query.athleteID, req.query.athleteSports],
          function(err, result){
          if(err){
            next(err);
            return;
          }
          //refresh the page
          res.redirect('back');
          //res.send('/');
        });
      }
      else {
        res.redirect('back');
      }
    }
  });
});

//delete athlete
app.get('/deleteAthlete',function(req,res,next){
  var context = {};
  mysql.pool.query("DELETE FROM athletes WHERE id=?", [req.query.athleteID], function(err, result){
    if(err){
      next(err);
      return;
    }
    //refresh the page
    res.redirect('back');
  });
});

/*EDIT FOCUS TABLE
--------------------------------------------------------------------------*/
app.get('/insertFocus',function(req,res,next){
  var context = {};
  var focQuery = "INSERT INTO focus (focus_type) VALUES (?)"
  mysql.pool.query(focQuery, [req.query.focus_type], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
    //res.send('/');
  });
  //SELECT LAST_INSERT_ID();
});

/*EDIT SPORT TABLE
--------------------------------------------------------------------------*/
app.get('/insertSport',function(req,res,next){
  var context = {};
  var query = "INSERT INTO sport (sport_name) VALUES (?)"
  mysql.pool.query(query, [req.query.sport_name], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
  });
});

/*EDIT FOCUS_SPORT TABLE
--------------------------------------------------------------------------*/
app.get('/addFocusSport',function(req,res,next){
  var context = {};
  var sport_focus_query = "INSERT INTO sport_focus (f_id, s_id) VALUES (?, ?)"
  /*var focusID = req.query.sportFocus;
  var sportID = req.query.focusSport;
  mysql.pool.query(sport_focus_query, [focusID, sportID], function(err, result){ */
  mysql.pool.query(sport_focus_query, [req.query.sportFocus, req.query.focusSport], function(err, result){
    if(err){
      console.log("querry error");
      next(err);
      return;
    }
    res.redirect('back');
    //res.send('/');
  });
});
//gets Error 404 - Page Is Nowhere to be Found
// from
// server.../addFocusSport?sportFocus=10&focusSport=6&add+focus-sport=create+focus-sport+relation

/*EDIT DIET TABLE
--------------------------------------------------------------------------*/
//add diet
app.get('/insertDiet',function(req,res,next){
  var context = {};
  var query = "INSERT INTO diet (diet_name, diet_type, diet_focus, description) VALUES (?, ?, ?, ?)";
  mysql.pool.query(query, [req.query.diet_name, req.query.diet_type,
                           req.query.diet_focus, req.query.description], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
    //res.send('/');
  });
});
//update diet
app.get('/updateDiet',function(req,res,next){
  var context = {};
  mysql.pool.query("SELECT * FROM diet WHERE id=?", [req.query.dietID], function(err, result){
    if(err){
      next(err);
      return;
    }
    if(result.length == 1){
      var curVals = result[0];
      mysql.pool.query("UPDATE diet SET diet_name=?, diet_type=?, diet_focus=?, description=? WHERE id=? ",
                       [req.query.diet_name || curVals.diet_name, req.query.diet_type || curVals.diet_type,
                        req.query.diet_focus || curVals.diet_focus, req.query.description || curVals.description,
                        req.query.dietID], function(err, result){
        if(err){
          next(err);
          return;
        }
        res.redirect('back');
      });
    }
  });
});

/* View Diets and Sports by Focus
--------------------------------------------------------------------------*/
app.get('/dataByFocus',function(req,res,next){
  var context = {};
  var focusFilterID = req.query.focusFilter;
  context.focusFilterID = focusFilterID;
  //get sports and diet by focus
  //a: get the foci for the form
  var focuses = "SELECT *  FROM focus;";
  mysql.pool.query(focuses, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var foci = [];
    for(var f in rows){
        var focus = { 'id': rows[f].id,
                      'focus_type': rows[f].focus_type};
        foci.push(focus);
    }
    context.foci = foci;
    console.log(context.foci);
  });
  //b: get the sports
  var FilterSports = "SELECT s.sport_name FROM sport_focus sf " +
                     "INNER JOIN sport s ON s.id = sf.s_id " +
                     "WHERE sf.f_id = " + focusFilterID + ";";
  mysql.pool.query(FilterSports, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var focusFilterSports = [];
    for(var f in rows){
        var focFilter = { 'sport_name': rows[f].sport_name};
        focusFilterSports.push(focFilter);
        console.log(focFilter);
    }
    context.focusFilterSports = focusFilterSports;
    console.log(context.focusFilterSports);
  });
  //b: get the diets
  var FilterDiets = "SELECT diet_name, diet_type, description FROM diet " +
                    "WHERE diet_focus = " + focusFilterID + ";";
  mysql.pool.query(FilterDiets, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var focusFilterDiets = [];
    for(var f in rows){
        var focFilter = { 'diet_name': rows[f].diet_name,
                          'diet_type': rows[f].diet_type,
                          'description': rows[f].description};
        focusFilterDiets.push(focFilter);
        console.log(focFilter);
    }
    context.focusFilterDiets = focusFilterDiets;
    console.log(context.focusFilterDiets);
    //res.redirect('back');
    res.render('focusFilter', context);
  });

});

/* View an athelte's sports
--------------------------------------------------------------------------*/
app.get('/mySports',function(req,res,next){
  var context = {};
  var athID = req.query.athID;
  var athQuery = "SELECT a. id, a.first_name, a.last_name, a.DOB, a.sex, a.fitness_level, " +
                "f.focus_type, d.diet_name, d.diet_type, a.interests FROM athletes a " +
                "INNER JOIN focus f ON a.athlete_focus = f.id "+
                "INNER JOIN diet d ON a.athlete_diet = d.id " +
                "WHERE a.id = " + athID;
  mysql.pool.query(athQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var athlist = [];
    var athCount = 0;
    // get each element we want to display in the table
    for(var ath in rows){
        var athlete = { 'id': rows[ath].id,
                        'name': rows[ath].last_name + ", " + rows[ath].first_name,
                        'DOB': rows[ath].DOB,
                        'sex': rows[ath].sex,
                        'fitness_level': rows[ath].fitness_level,
                        'focus_type': rows[ath].focus_type,
                        'diet_name': rows[ath].diet_name,
                        'diet_type': rows[ath].diet_type,
                        'interests': rows[ath].interests};
        athlist.push(athlete);
        athCount++;
    }
    context.athlete = athlist;

  });
  var query = "SELECT s.sport_name FROM sport s " +
              "INNER JOIN athletes_sports sa ON sa.s_id = s.id " +
              "INNER JOIN  athletes a ON sa.a_id = a.id " +
              "WHERE a.id = " + athID + ";";
  mysql.pool.query(query, focusFilterID, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var sports = [];
    for(var sp in rows){
        var sport = { 'sport_name': rows[sp].sport_name };
        sports.push(sport);
        //sports.push(rows[sp].sport_name);
      }
    //context.athSports = rows;
    context.sports = sports;
    console.log(context);
    res.render('athSports', context);
  });

});

app.get('/goBack', function(req, res, next){
  res.render('home');
  res.refresh('home');
});

app.use(function(req,res){
  res.status(404);
  res.render('404');
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function(){
  console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});



/* ------------- JUNKED ---------------------------------- *
/*-----------------------------------------------------------------------------------------*

  //get the athletes
  var genQuery = "SELECT a. id, a.first_name, a.last_name, a.DOB, a.sex, a.fitness_level, f.focus_type, d.diet_name, d.diet_type, a.interests FROM athletes a INNER JOIN focus f ON a.athlete_focus = f.id INNER JOIN diet d ON a.athlete_diet = d.id";
  mysql.pool.query(genQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var athlist = [];
    var athCount = 0;
    // get each element we want to display in the table
    for(var ath in rows){
        var athlete = { 'id': rows[ath].id,
                        'name': rows[ath].last_name + ", " + rows[ath].first_name,
                        'DOB': rows[ath].DOB,
                        'sex': rows[ath].sex,
                        'fitness_level': rows[ath].fitness_level,
                        'focus_type': rows[ath].focus_type,
                        'diet_name': rows[ath].diet_name,
                        'diet_type': rows[ath].diet_type,
                        'interests': rows[ath].interests};
        athlist.push(athlete);
        athCount++;
    }
    context.athletes = athlist;
    context.athCount = athCount;
    console.log(context.athletes);
  });

  var count = 0;
  //get their list of sports
  //for (var ath in context.athletes) { // or
  for(var i = 0; i < context.athCount; i++) {
    var athID = context.athletes[i].id;
    var sportsQuery = "SELECT s.sport_name FROM athletes_sports a_s INNER JOIN sport s ON s.id = a_s.s_id WHERE a_s.a_id = " + athID + ";";
    mysql.pool.query(sportsQuery, function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      console.log(rows);
      var sports = [];
      for(var sp in rows){
          var sport = { 'sport': rows[sp].sport_name };
          sports.push(sport);
          //sports.push(rows[sp].sport_name);
        }
        context.athletes[i].sports = sports;
        console.log(context.athletes[i].sports);
        //console.log(context.athlete[count]);
        console.log(count);
        count++;
      });
      //context.count = count;
      console.log("----------------------- Count is " + count + "! ---------------");
  }

  *-----------------------------------------------------------------------------------------------*/


/*-----------EX  @ http://stackoverflow.com/questions/29344879/nested-query-in-node-js-using-mysql
  connection.query(queryString, function(err, rows, fields) {
      if (err) throw err;

      async.each(rows, function (row, callback) {
          console.log('Product Name: ', row.product_name);
          var emp_query = 'SELECT * FROM tbl_employer';
          connection.query(queryString, function(emp_err, emp_rows, emp_fields) {
              if (emp_err) callback(emp_err);
              for (var e in emp_rows) {
                  console.log('Employer Name: ', emp_rows[e].company_name);
              }
              callback();
          });
      });
      }, function (err) {
          connection.end();
      }
  }); goes w whatever function is above the ex
-------------------------------------------------*/
