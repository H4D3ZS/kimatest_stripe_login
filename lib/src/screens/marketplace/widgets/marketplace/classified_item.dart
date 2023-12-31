import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kima/gen/assets.gen.dart';
import 'package:kima/src/blocs/main/classifieds/classified_details_cubit.dart';
import 'package:kima/src/data/models/classifieds_model.dart';
import 'package:kima/src/screens/classifieds/inner_classified_screen.dart';
import 'package:kima/src/utils/colors.dart';
import 'package:kima/src/utils/widgets/common/_common.dart';
import 'package:kima/src/utils/datetime.dart';

class ClassifiedItem extends StatefulWidget {
  ClassifiedItem({
    super.key,
    required this.classified
  });

  Classified classified;

  @override
  State<ClassifiedItem> createState() => _ClassifiedItemState();
}

class _ClassifiedItemState extends State<ClassifiedItem> {
  late ClassifiedDetailsCubit _classifiedDetailsCubit;

  final formatCurrency = NumberFormat.simpleCurrency();

  Widget categoryChecker({
    required Classified classified
  }) {
    switch (classified.category) {
      case 'events':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classified.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
                Text(classified.price ?? 'free',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.iconClock.svg(),
                const HorizontalSpace(5),
                Text('${getFormattedDate(date: classified.eventDate ?? '')} - ${getFormattedTime(classified.eventTime ?? '')}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ],
            )
          ],
        );
      case 'for_sale':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classified.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
                Text(classified.price != null ? formatCurrency.format(double.parse(classified.price!)) : 'free',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.iconCondition.svg(),
                const HorizontalSpace(5),
                Text(classified.itemCondition!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ],
            )
          ],
        );
      case 'job_posting':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classified.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
                Text(classified.price != null ? formatCurrency.format(double.parse(classified.price!)) : 'free',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.iconJob.svg(),
                const HorizontalSpace(5),
                Text(classified.itemCondition!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ],
            )
          ],
        );
      case 'misc':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classified.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            Text(
              classified.description!,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ],
        );
      case 'real_estate':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classified.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
                Text(classified.price != null ? formatCurrency.format(double.parse(classified.price!)) : '',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.iconLocationMarketplace.svg(),
                const HorizontalSpace(5),
                Text(classified.location!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ],
            )
          ],
        );
      default:
        return const SizedBox();
    }
  }

  void _initBloc() {
    _classifiedDetailsCubit = BlocProvider.of<ClassifiedDetailsCubit>(context);
  }

  @override
  void initState() {
    _initBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var classified = widget.classified;
    return InkWell(
      onTap: () {
        _classifiedDetailsCubit.select(context, classified);
        Navigator.pushNamed(context, InnerClassified.route);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.21,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.asset('assets/temporary/img_temp_3.png', fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  categoryChecker(classified: classified),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(classified.location!, style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: AppColors.lightGrey5
                      )),),
                      Text('Listed ${getFormattedDate(date: classified.createdAt ?? '', format: 'dd.MM.yyyy')}', style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: AppColors.lightGrey5
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}