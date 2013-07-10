# Bravesheep Bootstrapify bundle

To include the Bootstrap Datepicker add the following to your layout:

```twig
{% block javascripts %}
  {{ parent() }}
  {% javascripts filter='?yui_js'
    '@BsBootstrapifyBundle/Resources/js/bootstrap-datepicker.js'
  %}
    <script type="text/javascript" src="{{ asset_url }}"></script>
  {% endjavascripts %}
  <script type="text/javascript" src="{{ asset('bundles/bsbootstrapify/js/locale/datepicker/' ~ locale ~ '.js') }}"></script>
{% endblock %}
```

The main less source file can be extended by importing it in your own less file. Use the following statement to import the main less file (assumed the file is located in Bundle/Resources/less/):

```less
@import "../../../../../vendor/bravesheep/bootstrapify-bundle/Bs/BootstrapifyBundle/Resources/less/bootstrap-fa-s2.less";
```
