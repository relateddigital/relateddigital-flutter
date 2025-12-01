import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter/recommendation_filter.dart';

class Event extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Event({required this.relatedDigitalPlugin});

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  TextEditingController tController = TextEditingController();
  
  // Get Recommendations Form Controllers
  TextEditingController zoneIdController = TextEditingController(text: '83');
  TextEditingController productCodeController = TextEditingController();
  List<MapEntry<String, String>> properties = [];
  List<Map<String, dynamic>> filters = [];
  
  // Property controllers
  List<TextEditingController> propertyKeyControllers = [];
  List<TextEditingController> propertyValueControllers = [];
  
  // Filter controllers
  List<String?> filterAttributes = [];
  List<int?> filterTypes = [];
  List<TextEditingController> filterValueControllers = [];
  
  var inAppTypes = [
    'mini',
    'full',
    'full_image',
    'image_button',
    'image_text_button',
    'smile_rating',
    'nps_with_numbers',
    'nps',
    'alert_native',
    'alert_actionsheet',
    'subscription_email',
    'scratch_to_win',
    'nps-image-text-button',
    'nps-image-text-button-image',
    'nps-feedback',
    'spintowin',
    'half_screen_image',
    'product_stat_notifier',
    'inappcarousel',
    'drawer',
    'inline_anket',
    'nps_with_secondpopup',
    'MultipleChoiceSurvey',
    'notification_bell',
    'mobileCustomActions'
  ];
  String exVisitorId = '';

  @override
  void initState() {
    super.initState();
    setExVisitorID();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text(Constants.Event),
              backgroundColor: Styles.relatedOrange,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                            TextInputListTile(
                              title: Constants.exVisitorId,
                              controller: tController,
                              onChanged: (String exVisitor) {
                                exVisitorId = exVisitor;
                              },
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Login'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        login();
                                      })
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('GetExVisitorID'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        getExVisitorID();
                                      })
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Get Recommendations'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        _showRecommendationsForm();
                                      })
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Logout'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        logout();
                                      })
                                ],
                              ),
                            ),
                            Visibility(
                              visible: Platform.isAndroid,
                              child: ListTile(
                                subtitle: Column(
                                  children: <Widget>[
                                    TextButton(
                                        child: Text('App Tracking'),
                                        style: Styles.eventButtonStyle,
                                        onPressed: () {
                                          sendTheListOfAppsInstalled();
                                        })
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: Platform.isIOS,
                              child: ListTile(
                                subtitle: Column(
                                  children: <Widget>[
                                    TextButton(
                                        child: Text('Request IDFA'),
                                        style: Styles.eventButtonStyle,
                                        onPressed: () {
                                          requestIDFA();
                                        })
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Send Location Permission'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        sendLocationPermission();
                                      })
                                ],
                              ),
                            ),
                          ] +
                          getInAppListTiles())
                  .toList(),
            )));
  }

  List<StatelessWidget> getInAppListTiles() {
    List<StatelessWidget> tiles = [];
    for (final inAppType in inAppTypes) {
      tiles.add(ListTile(
        subtitle: Column(
          children: <Widget>[
            TextButton(
                child: Text(inAppType),
                style: Styles.inAppButtonStyle,
                onPressed: () {
                  Map<String, String> parameters = {'OM.inapptype': inAppType};
                  if (inAppType == 'product_stat_notifier') {
                    parameters['OM.pv'] = 'CV7933-837-837';
                  }
                  widget.relatedDigitalPlugin
                      .customEvent("InAppTest", parameters);
                })
          ],
        ),
      ));
    }
    return tiles;
  }

  void _showRecommendationsForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecommendationsForm(
        zoneIdController: zoneIdController,
        productCodeController: productCodeController,
        properties: properties,
        filters: filters,
        propertyKeyControllers: propertyKeyControllers,
        propertyValueControllers: propertyValueControllers,
        filterAttributes: filterAttributes,
        filterTypes: filterTypes,
        filterValueControllers: filterValueControllers,
        relatedDigitalPlugin: widget.relatedDigitalPlugin,
        onPropertiesChanged: (newProperties) {
          setState(() {
            properties = newProperties;
          });
        },
        onFiltersChanged: (newFilters) {
          setState(() {
            filters = newFilters;
          });
        },
        onPropertyControllersChanged: (keyControllers, valueControllers) {
          setState(() {
            propertyKeyControllers = keyControllers;
            propertyValueControllers = valueControllers;
          });
        },
        onFilterControllersChanged: (attributes, types, valueControllers) {
          setState(() {
            filterAttributes = attributes;
            filterTypes = types;
            filterValueControllers = valueControllers;
          });
        },
      ),
    );
  }

  Future<void> getRecommendations() async {
    String zoneId = '83';
    String productCode = '';

    // optional
    Map<String, Object> filter = {
      RDRecommendationFilter.attribute:
          RDRecommendationFilterAttribute.PRODUCTNAME,
      RDRecommendationFilter.filterType: RDRecommendationFilterType.like,
      RDRecommendationFilter.value: 'Honey'
    };

    List filters = [filter];

    // opttional
    Map<String, String> properties = {
       'OM.cat':'84'
    };

    Map<String, dynamic> result = await widget.relatedDigitalPlugin
        .getRecommendations(
          zoneId, 
          productCode: productCode, 
          properties:properties, 
          filters: filters);
    // widget.relatedDigitalPlugin.trackRecommendationClick(result[0]['qs']);
    print(result.toString());
  }

  void login() {
    widget.relatedDigitalPlugin.login(exVisitorId);
  }

  void setExVisitorID() async {
    exVisitorId = await widget.relatedDigitalPlugin.getExVisitorID();
    setState(() {
      tController.text = exVisitorId;
    });
  }

  void getExVisitorID() async {
    String exVisitorID = await widget.relatedDigitalPlugin.getExVisitorID();
    showAlertDialog(title: 'ExVisitorId', content: exVisitorID);
  }

  void logout() async {
    await widget.relatedDigitalPlugin.logout();
  }

  void sendTheListOfAppsInstalled() async {
    await widget.relatedDigitalPlugin.sendTheListOfAppsInstalled();
  }

  void requestIDFA() async {
    await widget.relatedDigitalPlugin.requestIDFA();
  }

  void sendLocationPermission() async {
    await widget.relatedDigitalPlugin.sendLocationPermission();
  }

  Future<dynamic> showAlertDialog({
    required String title,
    required String content,
  }) async {
    if (!Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _RecommendationsForm extends StatefulWidget {
  final TextEditingController zoneIdController;
  final TextEditingController productCodeController;
  final List<MapEntry<String, String>> properties;
  final List<Map<String, dynamic>> filters;
  final List<TextEditingController> propertyKeyControllers;
  final List<TextEditingController> propertyValueControllers;
  final List<String?> filterAttributes;
  final List<int?> filterTypes;
  final List<TextEditingController> filterValueControllers;
  final RelateddigitalFlutter relatedDigitalPlugin;
  final Function(List<MapEntry<String, String>>) onPropertiesChanged;
  final Function(List<Map<String, dynamic>>) onFiltersChanged;
  final Function(List<TextEditingController>, List<TextEditingController>) onPropertyControllersChanged;
  final Function(List<String?>, List<int?>, List<TextEditingController>) onFilterControllersChanged;

  _RecommendationsForm({
    required this.zoneIdController,
    required this.productCodeController,
    required this.properties,
    required this.filters,
    required this.propertyKeyControllers,
    required this.propertyValueControllers,
    required this.filterAttributes,
    required this.filterTypes,
    required this.filterValueControllers,
    required this.relatedDigitalPlugin,
    required this.onPropertiesChanged,
    required this.onFiltersChanged,
    required this.onPropertyControllersChanged,
    required this.onFilterControllersChanged,
  });

  @override
  _RecommendationsFormState createState() => _RecommendationsFormState();
}

class _RecommendationsFormState extends State<_RecommendationsForm> {
  String? responseJson;
  bool isLoading = false;
  
  final List<String> filterAttributeOptions = [
    RDRecommendationFilterAttribute.PRODUCTNAME,
    RDRecommendationFilterAttribute.COLOR,
    RDRecommendationFilterAttribute.AGEGROUP,
    RDRecommendationFilterAttribute.BRAND,
    RDRecommendationFilterAttribute.CATEGORY,
    RDRecommendationFilterAttribute.GENDER,
    RDRecommendationFilterAttribute.MATERIAL,
    RDRecommendationFilterAttribute.ATTRIBUTE1,
    RDRecommendationFilterAttribute.ATTRIBUTE2,
    RDRecommendationFilterAttribute.ATTRIBUTE3,
    RDRecommendationFilterAttribute.ATTRIBUTE4,
    RDRecommendationFilterAttribute.ATTRIBUTE5,
    RDRecommendationFilterAttribute.SHIPPINGONSAMEDAY,
    RDRecommendationFilterAttribute.FREESHIPPING,
    RDRecommendationFilterAttribute.ISDISCOUNTED,
  ];

  final Map<int, String> filterTypeOptions = {
    RDRecommendationFilterType.equals: 'Equals',
    RDRecommendationFilterType.notEquals: 'Not Equals',
    RDRecommendationFilterType.like: 'Like',
    RDRecommendationFilterType.notLike: 'Not Like',
    RDRecommendationFilterType.greaterThan: 'Greater Than',
    RDRecommendationFilterType.lessThan: 'Less Than',
    RDRecommendationFilterType.greaterOrEquals: 'Greater Or Equals',
    RDRecommendationFilterType.lessOrEquals: 'Less Or Equals',
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers if empty
    if (widget.propertyKeyControllers.isEmpty && widget.properties.isNotEmpty) {
      for (var entry in widget.properties) {
        widget.propertyKeyControllers.add(TextEditingController(text: entry.key));
        widget.propertyValueControllers.add(TextEditingController(text: entry.value));
      }
    }
    if (widget.filterValueControllers.isEmpty && widget.filters.isNotEmpty) {
      for (var filter in widget.filters) {
        widget.filterAttributes.add(filter[RDRecommendationFilter.attribute] as String?);
        widget.filterTypes.add(filter[RDRecommendationFilter.filterType] as int?);
        widget.filterValueControllers.add(TextEditingController(text: filter[RDRecommendationFilter.value]?.toString() ?? ''));
      }
    }
  }

  void _addProperty() {
    setState(() {
      widget.propertyKeyControllers.add(TextEditingController());
      widget.propertyValueControllers.add(TextEditingController());
    });
  }

  void _removeProperty(int index) {
    setState(() {
      widget.propertyKeyControllers[index].dispose();
      widget.propertyValueControllers[index].dispose();
      widget.propertyKeyControllers.removeAt(index);
      widget.propertyValueControllers.removeAt(index);
      if (index < widget.properties.length) {
        widget.properties.removeAt(index);
        widget.onPropertiesChanged(widget.properties);
      }
    });
  }

  void _addFilter() {
    setState(() {
      widget.filterAttributes.add(null);
      widget.filterTypes.add(null);
      widget.filterValueControllers.add(TextEditingController());
    });
  }

  void _removeFilter(int index) {
    setState(() {
      widget.filterValueControllers[index].dispose();
      widget.filterAttributes.removeAt(index);
      widget.filterTypes.removeAt(index);
      widget.filterValueControllers.removeAt(index);
      if (index < widget.filters.length) {
        widget.filters.removeAt(index);
        widget.onFiltersChanged(widget.filters);
      }
    });
  }

  Future<void> _submitForm() async {
    // Build properties map
    Map<String, String> propertiesMap = {};
    for (int i = 0; i < widget.propertyKeyControllers.length; i++) {
      String key = widget.propertyKeyControllers[i].text.trim();
      String value = widget.propertyValueControllers[i].text.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        propertiesMap[key] = value;
      }
    }

    // Build filters list
    List<Map<String, Object>> filtersList = [];
    for (int i = 0; i < widget.filterAttributes.length; i++) {
      String? attribute = widget.filterAttributes[i];
      int? filterType = widget.filterTypes[i];
      String value = widget.filterValueControllers[i].text.trim();
      
      if (attribute != null && filterType != null && value.isNotEmpty) {
        filtersList.add({
          RDRecommendationFilter.attribute: attribute,
          RDRecommendationFilter.filterType: filterType,
          RDRecommendationFilter.value: value,
        });
      }
    }

    String zoneId = widget.zoneIdController.text.trim();
    String productCode = widget.productCodeController.text.trim();

    if (zoneId.isEmpty) {
      _showError('Zone ID boş olamaz');
      return;
    }

    setState(() {
      isLoading = true;
      responseJson = null;
    });

    try {
      Map<String, dynamic> result = await widget.relatedDigitalPlugin
          .getRecommendations(
            zoneId,
            productCode: productCode,
            properties: propertiesMap,
            filters: filtersList);

      String jsonString = JsonEncoder.withIndent('  ').convert(result);
      
      setState(() {
        isLoading = false;
        responseJson = jsonString;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        responseJson = 'Hata: $e';
      });
    }
  }

  void _showError(String message) {
    if (!Platform.isIOS) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Styles.relatedOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Get Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Zone ID
                  TextField(
                    controller: widget.zoneIdController,
                    decoration: InputDecoration(
                      labelText: 'Zone ID *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Product Code
                  TextField(
                    controller: widget.productCodeController,
                    decoration: InputDecoration(
                      labelText: 'Product Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Properties Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Properties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addProperty,
                        tooltip: 'Property Ekle',
                      ),
                    ],
                  ),
                  ...List.generate(widget.propertyKeyControllers.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: widget.propertyKeyControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Key',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: widget.propertyValueControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Value',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeProperty(index),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 24),
                  // Filters Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addFilter,
                        tooltip: 'Filter Ekle',
                      ),
                    ],
                  ),
                  ...List.generate(widget.filterAttributes.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: widget.filterAttributes[index],
                                  decoration: InputDecoration(
                                    labelText: 'Attribute',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: filterAttributeOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      widget.filterAttributes[index] = newValue;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: widget.filterTypes[index],
                                  decoration: InputDecoration(
                                    labelText: 'Filter Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: filterTypeOptions.entries.map((entry) {
                                    return DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      widget.filterTypes[index] = newValue;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeFilter(index),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: widget.filterValueControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 24),
                  // Submit Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.relatedOrange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Gönder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  // Response View
                  if (responseJson != null) ...[
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Response',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.copy, size: 20),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: responseJson!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Kopyalandı!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    tooltip: 'Kopyala',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        responseJson = null;
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    tooltip: 'Kapat',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SelectableText(
                                responseJson!,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose controllers here as they're managed by parent
    super.dispose();
  }
}
