import 'dart:convert';
import 'dart:developer';
import 'package:eclass/model/zoom_meeting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../model/home_model.dart';
import 'package:http/http.dart' as http;
import 'courses_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeDataProvider with ChangeNotifier {
  HomeModel? homeModel;
  List<SliderFact>? sliderFactList = [];
  List<MySlider>? sliderList = [];
  List<Testimonial>? testimonialList = [];
  List<Trusted>? trustedList = [];
  List<MyCategory>? featuredCategoryList = [];
  List<SubCategory>? subCategoryList = [];
  List<MyCategory>? categoryList = [];
  List<ChildCategory>? childCategoryList = [];
  List<ZoomMeeting>? zoomMeetingList = [];
  Map categoryMap = {};

  void generateLists(HomeModel? homeData, BuildContext context) {
    CoursesProvider? courses =
        Provider.of<CoursesProvider>(context, listen: false);
    List<Course>? allCourses = courses.allCourses;

    generateSliderFactList(homeData!.sliderfacts);
    generateSliderList(homeData.slider);
    generateTestimonialList(homeData);
    generateTrustedList(homeData);
    generateFeaturedCategoryList(homeData, allCourses);
    generateCategoryList(homeData, allCourses);
    generateSubCateList(homeData, allCourses);
    generateChildCateList(homeData, allCourses);
    generateMeetingList(homeData.zoomMeeting);
  }
  Future<void> handleCloudFlareChallenge(String url, BuildContext context) async {
  try {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CloudFlareWebView(url: url),
      ),
    );
  } catch (e) {
    print('Error handling CloudFlare challenge: $e');
  }
}

  Future<HomeModel?> getHomeDetails(context) async {
    String url = "${APIData.home}${APIData.secretKey}";
    print(url);
      // await handleCloudFlareChallenge(url, context);

    http.Response res = await http.get(Uri.parse(url));
    log("Home API Status Code :-> ${res.statusCode}");
    log("Home API Response :-> ${res.body}");
    if (res.statusCode == 200) {
      homeModel = HomeModel.fromJson(json.decode(res.body));
      generateLists(homeModel, context);
      for (int i = 0; i < homeModel!.category!.length; i++) {
        categoryMap[homeModel!.category![i].id] = homeModel!.category![i].title;
      }
    } else {
       throw "Can't get home data";
    }
    notifyListeners();
    return homeModel;
  }

  void generateMeetingList(List<ZoomMeeting>? zoomMeeting) {
    zoomMeetingList = List.generate(
      zoomMeeting!.length,
      (index) => ZoomMeeting(
        id: zoomMeeting[index].id,
        courseId: zoomMeeting[index].courseId,
        meetingId: zoomMeeting[index].meetingId,
        meetingTitle: zoomMeeting[index].meetingTitle,
        startTime: zoomMeeting[index].startTime,
        zoomUrl: zoomMeeting[index].zoomUrl,
        userId: zoomMeeting[index].userId,
        agenda: zoomMeeting[index].agenda,
        createdAt: zoomMeeting[index].createdAt,
        updatedAt: zoomMeeting[index].updatedAt,
        type: zoomMeeting[index].type,
        linkBy: zoomMeeting[index].linkBy,
        ownerId: zoomMeeting[index].ownerId,
        image: zoomMeeting[index].image,
      ),
    );
  }

  void generateSliderFactList(List<SliderFact>? sliderfacts) {
    sliderFactList = List.generate(
      sliderfacts!.length,
      (index) => SliderFact(
        id: sliderfacts[index].id,
        icon: sliderfacts[index].icon,
        heading: sliderfacts[index].heading,
        subHeading: sliderfacts[index].subHeading,
        createdAt: sliderfacts[index].createdAt,
        updatedAt: sliderfacts[index].updatedAt,
      ),
    );
  }

  void generateSliderList(List<MySlider>? slider) {
    sliderList = List.generate(
      slider == null ? 0 : slider.length,
      (index) {
        return MySlider(
          id: slider![index].id,
          image: slider[index].image,
          heading: slider[index].heading,
          subHeading: slider[index].subHeading,
          detail: slider[index].detail,
          searchText: slider[index].searchText,
          position: slider[index].position,
          status: slider[index].status,
          createdAt: slider[index].createdAt,
          updatedAt: slider[index].updatedAt,
        );
      },
    );
  }

  void generateTestimonialList(HomeModel? homeModels) {
    testimonialList = List.generate(
      homeModels!.testimonial!.length,
      (index) => Testimonial(
        id: homeModels.testimonial![index].id,
        clientName: homeModels.testimonial![index].clientName,
        image: homeModels.testimonial![index].image,
        status: homeModels.testimonial![index].status,
        details: homeModels.testimonial![index].details,
        createdAt: homeModels.testimonial![index].createdAt,
        updatedAt: homeModels.testimonial![index].updatedAt,
      ),
    );
    testimonialList!.removeWhere((element) => element.status == "0");
  }

  void generateTrustedList(HomeModel? homeModels) {
    trustedList = List.generate(
      homeModels!.trusted!.length,
      (index) => Trusted(
        id: homeModels.trusted![index].id,
        url: homeModels.trusted![index].url,
        image: homeModels.trusted![index].image,
        status: homeModels.trusted![index].status,
        createdAt: homeModels.trusted![index].createdAt,
        updatedAt: homeModels.trusted![index].updatedAt,
      ),
    );
  }

  void generateFeaturedCategoryList(
      HomeModel? homeModels, List<Course>? allCourses) {
    featuredCategoryList = List.generate(
      homeModels!.featuredCate!.length,
      (index) => MyCategory(
        id: homeModels.featuredCate![index].id,
        slug: homeModels.featuredCate![index].slug,
        icon: homeModels.featuredCate![index].icon,
        title: homeModels.featuredCate![index].title,
        status: homeModels.featuredCate![index].status,
        featured: homeModels.featuredCate![index].featured,
        position: homeModels.featuredCate![index].position,
        updatedAt: homeModels.featuredCate![index].updatedAt,
        createdAt: homeModels.featuredCate![index].createdAt,
        catImage: homeModels.featuredCate![index].catImage,
      ),
    );
    featuredCategoryList!.removeWhere((element) => element.status == "0");

    List<int>? removeIds = [];

    featuredCategoryList!.forEach((featuredCategory) {
      bool isIdFound = false;
      allCourses!.forEach((course) {
        if (featuredCategory.id.toString() == course.categoryId) {
          isIdFound = true;
        }
      });
      if (!isIdFound) {
        removeIds.add(featuredCategory.id as int);
      }
    });

    if (removeIds.isNotEmpty) {
      removeIds.forEach((id) {
        featuredCategoryList!.removeWhere((element) => element.id == id);
      });
    }
  }

  void generateCategoryList(HomeModel? homeModels, List<Course>? allCourses) {
    categoryList = List.generate(
      homeModels!.category!.length,
      (index) => MyCategory(
        id: homeModels.category![index].id,
        title: homeModels.category![index].title,
        icon: homeModels.category![index].icon,
        slug: homeModels.category![index].slug,
        featured: homeModels.category![index].featured,
        status: homeModels.category![index].status,
        position: homeModels.category![index].position,
        createdAt: homeModels.category![index].createdAt,
        updatedAt: homeModels.category![index].updatedAt,
        catImage: homeModels.category![index].catImage,
      ),
    );
    categoryList!.removeWhere((element) => element.status == "0");

    List<int> removeIds = [];

    categoryList!.forEach((category) {
      bool isIdFound = false;
      allCourses!.forEach((course) {
        if (category.id.toString() == course.categoryId) {
          isIdFound = true;
        }
      });
      if (!isIdFound) {
        removeIds.add(category.id as int);
      }
    });

    if (removeIds.isNotEmpty) {
      removeIds.forEach((id) {
        categoryList!.removeWhere((element) => element.id == id);
      });
    }
  }

  void generateSubCateList(HomeModel? homeModels, List<Course>? allCourses) {
    subCategoryList = List.generate(
      homeModels!.subcategory!.length,
      (index) => SubCategory(
        id: homeModels.subcategory![index].id,
        icon: homeModels.subcategory![index].icon,
        categoryId: homeModels.subcategory![index].categoryId,
        status: homeModels.subcategory![index].status,
        slug: homeModels.subcategory![index].slug,
        title: homeModels.subcategory![index].title,
        createdAt: homeModels.subcategory![index].createdAt,
        updatedAt: homeModels.subcategory![index].updatedAt,
      ),
    );
    subCategoryList!.removeWhere((element) => element.status == "0");

    List<int> removeIds = [];

    subCategoryList!.forEach((subCategory) {
      bool isIdFound = false;
      allCourses!.forEach((course) {
        if (subCategory.id.toString() == course.subcategoryId) {
          isIdFound = true;
        }
      });
      if (!isIdFound) {
        removeIds.add(subCategory.id as int);
      }
    });

    if (removeIds.isNotEmpty) {
      removeIds.forEach((id) {
        subCategoryList!.removeWhere((element) => element.id == id);
      });
    }
  }

  void generateChildCateList(HomeModel? homeModels, List<Course>? allCourses) {
    childCategoryList = List.generate(
      homeModels!.childcategory!.length,
      (index) => ChildCategory(
        id: homeModels.childcategory![index].id,
        status: homeModels.childcategory![index].status,
        title: homeModels.childcategory![index].title,
        slug: homeModels.childcategory![index].slug,
        icon: homeModels.childcategory![index].icon,
        subcategoryId: homeModels.childcategory![index].subcategoryId,
        categoryId: homeModels.childcategory![index].categoryId,
        createdAt: homeModels.childcategory![index].createdAt,
        updatedAt: homeModels.childcategory![index].updatedAt,
      ),
    );
    childCategoryList!.removeWhere((element) => element.status == "0");

    List<int> removeIds = [];

    childCategoryList!.forEach((childCategory) {
      bool isIdFound = false;
      allCourses!.forEach((course) {
        if (childCategory.id.toString() == course.childcategoryId) {
          isIdFound = true;
        }
      });
      if (!isIdFound) {
        removeIds.add(childCategory.id as int);
      }
    });

    if (removeIds.isNotEmpty) {
      removeIds.forEach((id) {
        childCategoryList!.removeWhere((element) => element.id == id);
      });
    }
  }

  String getCategoryName(dynamic id) {
    if (id == null) {
      return '';
    }
    if (categoryMap[int.tryParse(id)] != null) {
      return categoryMap[int.tryParse(id)];
    }
    return "null";
  }

  String? getSubCategoryName(String? id) {
    String? subCategoryName;
    subCategoryList!.forEach((subCategory) {
      if (subCategory.id.toString() == id) {
        subCategoryName = subCategory.title.toString();
      }
    });
    return subCategoryName;
  }
}
class CloudFlareWebView extends StatefulWidget {
  final String url;

  const CloudFlareWebView({Key? key, required this.url}) : super(key: key);

  @override
  _CloudFlareWebViewState createState() => _CloudFlareWebViewState();
}

class _CloudFlareWebViewState extends State<CloudFlareWebView> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('CloudFlare Challenge'),
    ),
    body: WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
      },
      navigationDelegate: (NavigationRequest request) {
        return handleNavigationRequest(request);
      },
    ),
  );
}

  NavigationDecision handleNavigationRequest(NavigationRequest request) {
    if (!request.isForMainFrame) {
      return NavigationDecision.navigate;
    }

    // Check if the URL is the actual API endpoint
    if (request.url.toString().startsWith('${APIData.home}${APIData.secretKey}')) {
      // Cancel the navigation and return the API response
      _controller.evaluateJavascript('document.documentElement.innerText').then((apiResponse) {
        print('API Response: $apiResponse');
        // Process the API response here
      });

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }
}