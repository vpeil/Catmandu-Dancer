window.App = window.App || (function($, Backbone, _, dust) {
  'use strict';

  var module = _.extend({}, Backbone.Events);

  module.Quote = Backbone.Model.extend({
    urlRoot: '/api/quotes',

    validate: function(attrs) {
      if (!attrs.author || !attrs.quote) {
        return "Please fill in author and quote fields.";
      }
    }
  });

  module.Quotes = Backbone.Collection.extend({
    model: module.Quote,

    url: function() {
      return '/api/quotes/search/' + this.searchTerm;
    },

    initialize: function(opts) {
      module.on('search', this.search);
    },

    search: function(searchTerm) {
      var results = new module.Quotes();
      results.searchTerm = searchTerm;
      results.fetch({
        success: function() {
          module.trigger("search::results", results);
        },
        error: function(collection, response) {
          module.trigger("search::error", response);
        }
      })
    }
  });

  module.QuoteView = Backbone.View.extend({
    events: {
      'submit': 'save',
    },

    initialize: function(opts) {
      this.el = opts.el;
    },

    save: function(evt) {
      evt.preventDefault();

      var quote = new module.Quote({
        author: this.$el.find('#quote-author').val(),
        quote: this.$el.find('#quote-text').val()
      });

      quote.save({}, {
        success: function(model, response) {
          $('.alert-success').show();
        },
        error: function(model, response) {
          $('.alert-error').show();
        }
      });
    }
  });

  module.QuotesView = Backbone.View.extend({
    el: $('#quotes'),

    render: function() {
      var self = this;

      dust.loadSource(dust.compile($('#quotes-template').html(), 'quotes'));

      console.log(this.collection.toJSON());

      dust.render('quotes', { quotes: this.collection.toJSON() }, function(err, out) {
        if (err) console.warn('dust::error', err);
        self.$el.html(out);
      });

      return this;
    }
  });

  module.SearchView = Backbone.View.extend({

    events: {
      'click #search-trigger' : 'search'
    },

    initialize: function(opts) {
      this.el = opts.el;
      module.on('search::results', this.showResults, this);
    },

    search: function() {
      var searchTerm = this.$el.find('#search-field').val();

      if( searchTerm ) {
        var quotes = new module.Quotes();
        quotes.search(searchTerm);
      }
    },

    showResults: function(results) {
      var quotesView = new module.QuotesView({ collection: results });
      quotesView.render();
    }
  });

  return module;

})(jQuery, Backbone, _, dust);


$(function() {

  var search = $('#search-form').get(0);
  if (search) {
    console.log("init::searchview");
    window.searchView = new App.SearchView({ el: search });
  }

  var create = $('#create-form').get(0);
  if (create) {
    console.log("init::createview");
    window.createView = new App.QuoteView({ el: create });
  }

});
