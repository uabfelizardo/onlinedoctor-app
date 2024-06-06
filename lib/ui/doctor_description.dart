// import 'package:onlinedoctorapp/constants/constants.dart';
// import 'package:onlinedoctorapp/model/model.dart';
// import 'package:onlinedoctorapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DoctorDescription extends StatelessWidget {
  const DoctorDescription({
    Key? key,
    // required this.doctorInformationModel,
  }) : super(key: key);

  // final DoctorInformationModel doctorInformationModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "doctorInformationModel.title",
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.headline5,
                  children: [
                    TextSpan(text: "doctorInformationModel.specialist"),
                    const TextSpan(text: '  •  '),
                    TextSpan(text: "doctorInformationModel.hospital"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
              'Ornelo is one of the best doctors in the XXX. He has saved more than 1000 patients in the past 3 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule. '),
          SizedBox(height: 20),
          // const DoctorDetails(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.purple,
                ),
                child: Image.asset(
                  "AppImages.comments",
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      "AppText.makeAppointment",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
