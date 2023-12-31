import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kima/gen/assets.gen.dart';
import 'package:kima/src/blocs/main/classifieds/classified_details_cubit.dart';
import 'package:kima/src/data/providers/member_provider.dart';
import 'package:kima/src/screens/marketplace/widgets/classifieds_description/classifieds_description.dart';
import 'package:kima/src/utils/colors.dart';
import 'package:kima/src/utils/mixins.dart';
import 'package:kima/src/utils/widgets/common/_common.dart';
import 'package:kima/src/utils/widgets/common/header_wrapper.dart';
import 'package:kima/src/utils/widgets/customs/custom_carousel_indicator/custom_carousel_indicator.dart';
import 'package:kima/src/utils/widgets/customs/custom_text.dart';

class InnerClassified extends StatefulWidget {
  const InnerClassified({Key? key});

  static const route = '/inner-classified';

  @override
  State<InnerClassified> createState() => _InnerClassifiedState();
}

class _InnerClassifiedState extends State<InnerClassified> with DialogMixins {
  MemberProvider memberProvider = MemberProvider();

  List<String> images = [
    'assets/temporary/img_temp_1.png',
    'assets/temporary/img_temp_2.jpeg',
    'assets/temporary/img_temp_3.png',
  ];

  String avatar = 'assets/temporary/img_temp_3.png';
  late String username = 'John Doe';
  late String joinedDate = '2023';

  String getFormattedDate({
    required String date,
    String? format = 'MMM dd, yyyy',
  }) {
    final parsed = DateTime.parse(date);
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(parsed);
    return formatted;
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> mapCategory = {
    'events': 'events',
    'for_sale': 'for sale',
    'misc': 'miscellaneous',
    'job_posting': 'job posting',
    'real_estate': 'real estate'
  };

  @override
  Widget build(BuildContext context) {
    final _classifiedDetailsCubit =
        BlocProvider.of<ClassifiedDetailsCubit>(context).state;
    final formatCurrency = NumberFormat.simpleCurrency();

    return HeaderWrapper(
      titleHeader: 'Description',
      onBack: () => Navigator.pop(context),
      elevation: 1,
      actions: [
        CircularIconButton(
          icon: Assets.icons.moreVertical.svg(),
          bgColor: AppColors.lightGrey20,
          width: 50.0,
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          onTap: () => showDescriptionModalBottomSheet(context),
        ),
      ],
      toolbarHeight: 95,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClassifiedsHeader(
              category: mapCategory[_classifiedDetailsCubit!.category!],
              title: _classifiedDetailsCubit.title ?? 'N/A',
              subtitle: _classifiedDetailsCubit.price != null
                  ? formatCurrency.format(
                      double.parse(_classifiedDetailsCubit.price!))
                  : '',
              author: username,
              listingDate: getFormattedDate(
                  date: _classifiedDetailsCubit.createdAt!,
                  format: 'dd.MM.yyyy'),
            ),
            CustomCarouselIndicator(
              height: 300.0,
              children: images
                  .map((img) => Image.asset(
                        img,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClassifiedsUserFavorite(
                    id: _classifiedDetailsCubit.id,
                    user: username,
                    joinedDate: joinedDate,
                    avatar: avatar,
                    onFavorite: (bool isFavorite) async {
                      if (!isFavorite) {
                        await memberProvider.setFavorite(
                            profileID: _classifiedDetailsCubit.id!);
                      } else {
                        await memberProvider.setUnFavorite(
                            profileID: _classifiedDetailsCubit.id!);
                      }
                    },
                  ),
                  const VerticalSpace(20.0),
                  const ClassifiedsMessageBox(),
                  if (true)
                    ClassifiedsDescriptionBox(
                        _classifiedDetailsCubit.description ?? 'N/A'),
                  if (true)
                    ...[
                      const VerticalSpace(30.0),
                      const CustomText(
                        'Additional Details',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                      const VerticalSpace(15.0),
                      ClassifiedsItemDetail(
                          label: 'Location',
                          value: _classifiedDetailsCubit.location!),
                      ClassifiedsItemDetail(
                          label: 'Price',
                          value: formatCurrency.format(double.parse(
                              _classifiedDetailsCubit.price!))),
                    ],
                  const VerticalSpace(60.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
