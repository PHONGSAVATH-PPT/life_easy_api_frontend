import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/life_bloc.dart';
import '../domain/models.dart';

const ink = Color(0xFF193F39);
const brand = Color(0xFF216B58);
const canvas = Color(0xFFF6F7F2);
const muted = Color(0xFF76817B);
const amber = Color(0xFFD9913F);

ThemeData buildTheme(String language) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: brand),
    scaffoldBackgroundColor: canvas,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    appBarTheme: const AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F4F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: brand,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFECF0E9), space: 1),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE5EEDC),
      labelTextStyle: WidgetStatePropertyAll(base.textTheme.labelSmall),
    ),
  );
}

String tr(BuildContext context, String key) {
  final language = context.read<LifeBloc>().state.language;

  final translations = switch (language) {
    'lo' => _lo,
    'en' => _en,
    'zh' => _zh,
    _ => _th,
  };

  return translations[key] ?? _th[key] ?? key;
}

const _th = {
  'today': 'วันนี้',
  'tasks': 'งาน',
  'money': 'การเงิน',
  'documents': 'เอกสาร',
  'family': 'ครอบครัว',
  'greeting': 'สวัสดี, วันนี้เป็นอย่างไรบ้าง',
  'subtitle': 'จัดเรื่องสำคัญ ให้ชีวิตเบาขึ้น',
  'overview': 'ภาพรวมวันนี้',
  'focus': 'เริ่มวันดี ๆ ทีละเรื่อง',
  'focusSub': 'งาน บิล และเอกสารสำคัญ\nอยู่ด้วยกันในพื้นที่เดียว',
  'pending': 'งานที่ต้องทำ',
  'bills': 'บิลรอชำระ',
  'expiring': 'ใกล้หมดอายุ',
  'quick': 'เพิ่มรายการ',
  'newTask': 'เพิ่มงาน',
  'newExpense': 'บันทึกเงิน',
  'newDocument': 'เพิ่มเอกสาร',
  'schedule': 'สิ่งที่ต้องจัดการ',
  'viewAll': 'ดูทั้งหมด',
  'all': 'ทั้งหมด',
  'open': 'ยังไม่เสร็จ',
  'done': 'เสร็จแล้ว',
  'taskSub': 'วางแผนวันนี้ และวันถัดไป',
  'moneySub': 'รู้เงินเข้า เห็นเงินออก',
  'documentSub': 'เอกสารสำคัญ อยู่ใกล้มือ',
  'familySub': 'ช่วยกันดูแลเรื่องในบ้าน',
  'balance': 'คงเหลือจากรายการที่บันทึก',
  'income': 'รายรับ',
  'expense': 'รายจ่าย',
  'transactions': 'รายการเงิน',
  'billTab': 'บิล',
  'pay': 'บันทึกชำระ',
  'paid': 'ชำระแล้ว',
  'unpaid': 'รอชำระ',
  'thisMonth': 'เดือนนี้',
  'private': 'ส่วนตัว',
  'shared': 'ครอบครัว',
  'expiry': 'หมดอายุ',
  'members': 'สมาชิก',
  'sharedItems': 'รายการที่แชร์',
  'house': 'บ้านของเรา',
  'houseSub': 'พื้นที่เล็ก ๆ สำหรับทุกคนในบ้าน',
  'owner': 'เจ้าของพื้นที่',
  'member': 'สมาชิก',
  'invite': 'เชิญสมาชิก',
  'inviteInfo': 'ส่วนนี้เป็นดีไซน์ ยังไม่ได้ส่งคำเชิญจริง',
  'empty': 'ยังไม่มีรายการ',
  'emptySub': 'เริ่มเพิ่มเรื่องแรกของคุณได้เลย',
  'add': 'เพิ่มรายการ',
  'settings': 'ตั้งค่า',
  'language': 'ภาษาเมนู',
  'currency': 'สกุลเงินเริ่มต้น',
  'demoInfo': 'ข้อมูลอยู่ในหน่วยความจำ ปิดแอปแล้วกลับเป็นค่าเริ่มต้น',
  'prototype': 'Part 1 · Frontend design',
  'notifications': 'รายการเตือน',
  'notificationInfo': 'แสดงรายการที่เปิดเตือนไว้ ยังไม่ส่งแจ้งเตือน Android',
  'save': 'บันทึก',
  'cancel': 'ยกเลิก',
  'title': 'ชื่อรายการ',
  'type': 'ประเภทรายการ',
  'date': 'วันที่ / วันครบกำหนด',
  'time': 'เวลา',
  'amount': 'จำนวนเงิน',
  'note': 'รายละเอียดเพิ่มเติม',
  'share': 'แชร์กับครอบครัว',
  'shareSub': 'เลือกเฉพาะรายการที่ต้องการให้สมาชิกเห็น',
  'reminder': 'เตือนรายการนี้',
  'reminderSub': 'บันทึกค่าที่เลือก ยังไม่ส่งแจ้งเตือนจริง',
  'repeat': 'ทำซ้ำ',
  'none': 'ไม่ทำซ้ำ',
  'monthly': 'ทุกเดือน',
  'assignee': 'ผู้รับผิดชอบ',
  'unassigned': 'ยังไม่มอบหมาย',
  'required': 'กรุณากรอกชื่อรายการ',
  'validAmount': 'กรอกจำนวนเงินมากกว่า 0 ให้ถูกต้อง',
  'edit': 'แก้ไข',
  'delete': 'ลบรายการ',
  'deleteAsk': 'ต้องการลบรายการนี้หรือไม่?',
  'details': 'รายละเอียด',
  'task': 'งานทั่วไป',
  'appointment': 'นัดหมาย',
  'bill': 'บิล',
  'document': 'เอกสาร',
  'attachInfo': 'Part 1 เก็บชื่อและวันหมดอายุ ยังไม่ได้แนบหรืออัปโหลดไฟล์',
  'recurrenceInfo': 'บันทึกกติกาทำซ้ำ ยังไม่สร้างรอบถัดไปอัตโนมัติ',
  'noFile': 'ยังไม่มีไฟล์แนบ',
  'error': 'โหลดข้อมูลไม่สำเร็จ',
  'retry': 'ลองอีกครั้ง',
  'search': 'ค้นหาชื่อเอกสาร',
  'smart': 'พิมพ์เพื่อเตรียมรายการ',
  'smartHint': 'จ่ายค่าเน็ต 250,000 กีบ ทุกวันที่ 5',
  'preview': 'ตรวจข้อมูลก่อนบันทึก',
  'smartInfo': 'ตัวช่วยตัวอย่างสำหรับบิลกีบ วันที่ 1–28 กรุณาตรวจทุกช่อง',
  'smartError': 'ลองพิมพ์ “จ่ายค่าเน็ต 250,000 กีบ ทุกวันที่ 5”',
  'completed': 'งานเสร็จแล้ว',
  'readonlyPayment': 'รายการชำระแล้วดูได้อย่างเดียวใน Part 1',
  'noShared': 'ยังไม่มีรายการที่แชร์',
};

const _en = {
  'today': 'Today',
  'tasks': 'Tasks',
  'money': 'Money',
  'documents': 'Documents',
  'family': 'Family',
  'greeting': 'Hello, how are you today?',
  'subtitle': 'Keep important things simple',
  'overview': 'Today’s overview',
  'focus': 'Start your day, one thing at a time',
  'focusSub': 'Tasks, bills, and important documents\nin one place',
  'pending': 'Tasks to do',
  'bills': 'Bills due',
  'expiring': 'Expiring soon',
  'quick': 'Quick add',
  'newTask': 'Add task',
  'newExpense': 'Record expense',
  'newDocument': 'Add document',
  'schedule': 'Things to manage',
  'viewAll': 'View all',
  'all': 'All',
  'open': 'Open',
  'done': 'Done',
  'taskSub': 'Plan today and the days ahead',
  'moneySub': 'See what comes in and goes out',
  'documentSub': 'Keep important documents close',
  'familySub': 'Take care of home matters together',
  'balance': 'Balance from recorded entries',
  'income': 'Income',
  'expense': 'Expenses',
  'transactions': 'Transactions',
  'billTab': 'Bills',
  'pay': 'Mark as paid',
  'paid': 'Paid',
  'unpaid': 'Unpaid',
  'thisMonth': 'This month',
  'private': 'Private',
  'shared': 'Family',
  'expiry': 'Expiry',
  'members': 'Members',
  'sharedItems': 'Shared items',
  'house': 'Our home',
  'houseSub': 'A small space for everyone at home',
  'owner': 'Owner',
  'member': 'Member',
  'invite': 'Invite member',
  'inviteInfo': 'This is a design preview; invitations are not sent yet.',
  'empty': 'No entries yet',
  'emptySub': 'Start by adding your first item',
  'add': 'Add item',
  'settings': 'Settings',
  'language': 'App language',
  'currency': 'Default currency',
  'demoInfo': 'Data is stored in memory and resets when the app closes.',
  'prototype': 'Part 1 · Frontend design',
  'notifications': 'Reminders',
  'notificationInfo': 'Shows entries with reminders enabled; Android notifications are not sent yet.',
  'save': 'Save',
  'cancel': 'Cancel',
  'title': 'Title',
  'type': 'Type',
  'date': 'Date / due date',
  'time': 'Time',
  'amount': 'Amount',
  'note': 'Additional details',
  'share': 'Share with family',
  'shareSub': 'Choose only the entries you want family members to see',
  'reminder': 'Reminder for this entry',
  'reminderSub': 'Saves this setting but does not send real notifications yet.',
  'repeat': 'Repeat',
  'none': 'Does not repeat',
  'monthly': 'Monthly',
  'assignee': 'Assignee',
  'unassigned': 'Unassigned',
  'required': 'Please enter a title',
  'validAmount': 'Enter a valid amount greater than 0',
  'edit': 'Edit',
  'delete': 'Delete entry',
  'deleteAsk': 'Do you want to delete this entry?',
  'details': 'Details',
  'task': 'General task',
  'appointment': 'Appointment',
  'bill': 'Bill',
  'document': 'Document',
  'attachInfo': 'Part 1 stores a name and expiry date; file attachments are not available yet.',
  'recurrenceInfo': 'The repeat rule is saved, but future entries are not created automatically.',
  'noFile': 'No file attached',
  'error': 'Could not load data',
  'retry': 'Try again',
  'search': 'Search document names',
  'smart': 'Type to prepare an entry',
  'smartHint': 'Pay internet bill 250,000 kip on the 5th of every month',
  'preview': 'Review before saving',
  'smartInfo': 'A sample helper for kip bills on days 1–28. Please check every field.',
  'smartError': 'Try typing “Pay internet bill 250,000 kip on the 5th”.',
  'completed': 'Completed',
  'readonlyPayment': 'Paid entries are read-only in Part 1.',
  'noShared': 'No shared entries yet',
};

const _zh = {
  'today': '今天',
  'tasks': '任务',
  'money': '财务',
  'documents': '文件',
  'family': '家庭',
  'greeting': '你好，今天过得怎么样？',
  'subtitle': '轻松管理重要事务',
  'overview': '今日概览',
  'focus': '从一件小事开始美好的一天',
  'focusSub': '任务、账单和重要文件\n都集中在一个地方',
  'pending': '待办任务',
  'bills': '待付账单',
  'expiring': '即将到期',
  'quick': '快速添加',
  'newTask': '添加任务',
  'newExpense': '记录支出',
  'newDocument': '添加文件',
  'schedule': '待处理事项',
  'viewAll': '查看全部',
  'all': '全部',
  'open': '未完成',
  'done': '已完成',
  'taskSub': '安排今天和未来的计划',
  'moneySub': '清楚了解收入与支出',
  'documentSub': '重要文件随时可用',
  'familySub': '一起照顾家里的大小事',
  'balance': '已记录项目的余额',
  'income': '收入',
  'expense': '支出',
  'transactions': '交易记录',
  'billTab': '账单',
  'pay': '标记为已支付',
  'paid': '已支付',
  'unpaid': '未支付',
  'thisMonth': '本月',
  'private': '个人',
  'shared': '家庭',
  'expiry': '到期日',
  'members': '成员',
  'sharedItems': '共享项目',
  'house': '我们的家',
  'houseSub': '属于家中每个人的小空间',
  'owner': '所有者',
  'member': '成员',
  'invite': '邀请成员',
  'inviteInfo': '此处为设计预览，尚未发送真实邀请。',
  'empty': '还没有项目',
  'emptySub': '先添加你的第一个项目吧',
  'add': '添加项目',
  'settings': '设置',
  'language': '应用语言',
  'currency': '默认货币',
  'demoInfo': '数据仅保存在内存中，关闭应用后将重置。',
  'prototype': '第 1 部分 · 前端设计',
  'notifications': '提醒',
  'notificationInfo': '显示已开启提醒的项目；暂不发送 Android 通知。',
  'save': '保存',
  'cancel': '取消',
  'title': '项目名称',
  'type': '类型',
  'date': '日期 / 截止日期',
  'time': '时间',
  'amount': '金额',
  'note': '更多说明',
  'share': '与家人共享',
  'shareSub': '仅选择希望家人看到的项目',
  'reminder': '提醒此项目',
  'reminderSub': '会保存此设置，但暂不发送真实通知。',
  'repeat': '重复',
  'none': '不重复',
  'monthly': '每月',
  'assignee': '负责人',
  'unassigned': '未分配',
  'required': '请输入项目名称',
  'validAmount': '请输入大于 0 的有效金额',
  'edit': '编辑',
  'delete': '删除项目',
  'deleteAsk': '要删除此项目吗？',
  'details': '详情',
  'task': '一般任务',
  'appointment': '预约',
  'bill': '账单',
  'document': '文件',
  'attachInfo': '第 1 部分仅保存名称和到期日，暂不支持附件。',
  'recurrenceInfo': '会保存重复规则，但不会自动创建下一期项目。',
  'noFile': '没有附件',
  'error': '无法加载数据',
  'retry': '重试',
  'search': '搜索文件名称',
  'smart': '输入内容以准备项目',
  'smartHint': '每月 5 日支付网费 250,000 基普',
  'preview': '保存前确认',
  'smartInfo': '这是 1–28 日基普账单的示例助手。请检查所有字段。',
  'smartError': '请尝试输入“每月 5 日支付网费 250,000 基普”。',
  'completed': '已完成',
  'readonlyPayment': '已支付的项目在第 1 部分中仅可查看。',
  'noShared': '还没有共享项目',
};

const _lo = {
  'today': 'ມື້ນີ້',
  'tasks': 'ວຽກ',
  'money': 'ການເງິນ',
  'documents': 'ເອກະສານ',
  'family': 'ຄອບຄົວ',
  'greeting': 'ສະບາຍດີ, ມື້ນີ້ເປັນແນວໃດ',
  'subtitle': 'ຈັດການເລື່ອງສຳຄັນ ໃຫ້ຊີວິດງ່າຍຂຶ້ນ',
  'overview': 'ພາບລວມມື້ນີ້',
  'focus': 'ເລີ່ມມື້ດີໆ ເທື່ອລະເລື່ອງ',
  'focusSub': 'ວຽກ ບິນ ແລະ ເອກະສານສຳຄັນ\nຢູ່ຮ່ວມກັນໃນບ່ອນດຽວ',
  'pending': 'ວຽກທີ່ຕ້ອງເຮັດ',
  'bills': 'ບິນລໍຖ້າຈ່າຍ',
  'expiring': 'ໃກ້ໝົດອາຍຸ',
  'quick': 'ເພີ່ມລາຍການ',
  'newTask': 'ເພີ່ມວຽກ',
  'newExpense': 'ບັນທຶກເງິນ',
  'newDocument': 'ເພີ່ມເອກະສານ',
  'schedule': 'ເລື່ອງທີ່ຕ້ອງຈັດການ',
  'viewAll': 'ເບິ່ງທັງໝົດ',
  'all': 'ທັງໝົດ',
  'open': 'ຍັງບໍ່ແລ້ວ',
  'done': 'ສຳເລັດ',
  'taskSub': 'ວາງແຜນມື້ນີ້ ແລະ ມື້ຕໍ່ໄປ',
  'moneySub': 'ຮູ້ເງິນເຂົ້າ ເຫັນເງິນອອກ',
  'documentSub': 'ເອກະສານສຳຄັນ ຢູ່ໃກ້ມື',
  'familySub': 'ຊ່ວຍກັນດູແລເລື່ອງໃນບ້ານ',
  'balance': 'ຍອດຄົງເຫຼືອຈາກລາຍການ',
  'income': 'ລາຍຮັບ',
  'expense': 'ລາຍຈ່າຍ',
  'transactions': 'ລາຍການເງິນ',
  'billTab': 'ບິນ',
  'pay': 'ບັນທຶກຊຳລະ',
  'paid': 'ຊຳລະແລ້ວ',
  'unpaid': 'ລໍຖ້າຈ່າຍ',
  'thisMonth': 'ເດືອນນີ້',
  'private': 'ສ່ວນຕົວ',
  'shared': 'ຄອບຄົວ',
  'expiry': 'ໝົດອາຍຸ',
  'members': 'ສະມາຊິກ',
  'sharedItems': 'ລາຍການທີ່ແບ່ງປັນ',
  'house': 'ບ້ານຂອງພວກເຮົາ',
  'houseSub': 'ພື້ນທີ່ນ້ອຍໆ ສຳລັບທຸກຄົນໃນບ້ານ',
  'owner': 'ເຈົ້າຂອງ',
  'member': 'ສະມາຊິກ',
  'invite': 'ເຊີນສະມາຊິກ',
  'inviteInfo': 'ສ່ວນນີ້ເປັນດີໄຊນ໌ ຍັງບໍ່ໄດ້ສົ່ງຄຳເຊີນ',
  'empty': 'ຍັງບໍ່ມີລາຍການ',
  'emptySub': 'ເລີ່ມເພີ່ມເລື່ອງທຳອິດຂອງທ່ານ',
  'add': 'ເພີ່ມລາຍການ',
  'settings': 'ຕັ້ງຄ່າ',
  'language': 'ພາສາເມນູ',
  'currency': 'ສະກຸນເງິນເລີ່ມຕົ້ນ',
  'demoInfo': 'ຂໍ້ມູນຢູ່ໃນໜ່ວຍຄວາມຈຳ ປິດແອັບແລ້ວຈະກັບຄ່າເລີ່ມຕົ້ນ',
  'prototype': 'Part 1 · Frontend design',
  'notifications': 'ລາຍການແຈ້ງເຕືອນ',
  'notificationInfo': 'ສະແດງລາຍການທີ່ເປີດເຕືອນ ຍັງບໍ່ສົ່ງແຈ້ງເຕືອນ Android',
  'save': 'ບັນທຶກ',
  'cancel': 'ຍົກເລີກ',
  'title': 'ຊື່ລາຍການ',
  'type': 'ປະເພດ',
  'date': 'ວັນທີ / ວັນຄົບກຳນົດ',
  'time': 'ເວລາ',
  'amount': 'ຈຳນວນເງິນ',
  'note': 'ລາຍລະອຽດ',
  'share': 'ແບ່ງປັນກັບຄອບຄົວ',
  'shareSub': 'ເລືອກສະເພາະລາຍການທີ່ຕ້ອງການ',
  'reminder': 'ເຕືອນລາຍການນີ້',
  'reminderSub': 'ບັນທຶກຄ່າເທົ່ານັ້ນ ຍັງບໍ່ສົ່ງແຈ້ງເຕືອນ',
  'repeat': 'ເຮັດຊ້ຳ',
  'none': 'ບໍ່ເຮັດຊ້ຳ',
  'monthly': 'ທຸກເດືອນ',
  'assignee': 'ຜູ້ຮັບຜິດຊອບ',
  'unassigned': 'ຍັງບໍ່ມອບໝາຍ',
  'required': 'ກະລຸນາປ້ອນຊື່',
  'validAmount': 'ປ້ອນຈຳນວນເງິນຫຼາຍກວ່າ 0 ໃຫ້ຖືກຕ້ອງ',
  'edit': 'ແກ້ໄຂ',
  'delete': 'ລຶບລາຍການ',
  'deleteAsk': 'ຕ້ອງການລຶບລາຍການນີ້ບໍ?',
  'details': 'ລາຍລະອຽດ',
  'task': 'ວຽກທົ່ວໄປ',
  'appointment': 'ນັດໝາຍ',
  'bill': 'ບິນ',
  'document': 'ເອກະສານ',
  'attachInfo': 'Part 1 ເກັບຊື່ ແລະ ວັນໝົດອາຍຸ ຍັງບໍ່ໄດ້ແນບໄຟລ໌',
  'recurrenceInfo': 'ບັນທຶກກົດເຮັດຊ້ຳ ຍັງບໍ່ສ້າງຮອບຕໍ່ໄປ',
  'noFile': 'ຍັງບໍ່ມີໄຟລ໌ແນບ',
  'error': 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
  'retry': 'ລອງໃໝ່',
  'search': 'ຄົ້ນຫາຊື່ເອກະສານ',
  'smart': 'ພິມເພື່ອກຽມລາຍການ',
  'smartHint': 'ຈ່າຍຄ່າເນັດ 250,000 ກີບ ທຸກວັນທີ 5',
  'preview': 'ກວດຂໍ້ມູນກ່ອນບັນທຶກ',
  'smartInfo': 'ຕົວຊ່ວຍບິນກີບ ວັນທີ 1–28 ກະລຸນາກວດທຸກຊ່ອງ',
  'smartError': 'ລອງພິມ “ຈ່າຍຄ່າເນັດ 250,000 ກີບ ທຸກວັນທີ 5”',
  'completed': 'ວຽກສຳເລັດ',
  'readonlyPayment': 'ລາຍການຊຳລະແລ້ວເບິ່ງໄດ້ຢ່າງດຽວໃນ Part 1',
  'noShared': 'ຍັງບໍ່ມີລາຍການແບ່ງປັນ',
};

IconData kindIcon(EntryKind kind) => switch (kind) {
  EntryKind.task => Icons.check_circle_outline_rounded,
  EntryKind.appointment => Icons.calendar_today_rounded,
  EntryKind.income => Icons.south_west_rounded,
  EntryKind.expense => Icons.north_east_rounded,
  EntryKind.bill => Icons.receipt_long_rounded,
  EntryKind.document => Icons.description_outlined,
};

Color kindColor(EntryKind kind) => switch (kind) {
  EntryKind.task || EntryKind.income => brand,
  EntryKind.appointment => const Color(0xFF6675B5),
  EntryKind.bill || EntryKind.expense => amber,
  EntryKind.document => const Color(0xFF5B8B97),
};

String dateText(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String timeText(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEBEEE6)),
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          if (action != null)
            TextButton(onPressed: onTap, child: Text(action!)),
        ],
      ),
    );
  }
}

class InfoNote extends StatelessWidget {
  const InfoNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ),
        ],
      ),
    );
  }
}
