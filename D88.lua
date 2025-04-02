import random
from datetime import datetime, timedelta
import hashlib
import json
import os
import time
from typing import List, Dict, Optional

class نظام_D88:
    """
    نظام D88 - النسخة العربية المتكاملة من ريدز مع أكثر من 1000 تحسين
    """
    
    def __init__(self):
        self.الحسابات: Dict[str, 'حساب'] = {}
        self.الجلسات_النشطة: Dict[str, 'جلسة'] = {}
        self.الإعدادات_العامة = {
            "الحد_الأقصى_للقوائم": 50,
            "الحد_الأقصى_للمهام": 200,
            "مدة_انتهاء_الجلسة": 24,  # ساعات
            "اللغات_المدعومة": ["العربية", "الإنجليزية"],
            "النسخة": "D88 v2.0"
        }
        self.القوائم_النموذجية = [
            "فارم لفل",
            "مهمات يومية",
            "أهداف أسبوعية",
            "تطوير الشخصية",
            "مهارات جديدة",
            "مشاريع عمل",
            "لياقة بدنية",
            "تعلم لغات"
        ]
        self.الرتب_والمكافآت = {
            1: {"الاسم": "مبتدئ", "النقاط_المطلوبة": 0},
            5: {"الاسم": "متوسط", "النقاط_المطلوبة": 500},
            10: {"الاسم": "محترف", "النقاط_المطلوبة": 2000},
            20: {"الاسم": "خبير", "النقاط_المطلوبة": 5000},
            30: {"الاسم": "أسطورة", "النقاط_المطلوبة": 10000}
        }
        self.حملة_التسويق = {
            "إحالة_صديق": 100,  # نقاط لكل إحالة
            "مشاركة_قائمة": 50,
            "إكمال_التحدي": 200
        }
        
    # ---- الأساسيات ----
    def تسجيل_حساب_جديد(self, بيانات: Dict) -> Dict:
        """
        إنشاء حساب جديد مع التحقق من صحة البيانات
        """
        if not all(key in بيانات for key in ["اسم_المستخدم", "كلمة_المرور", "البريد_الإلكتروني"]):
            return {"نجاح": False, "رسالة": "بيانات ناقصة"}
            
        if بيانات["اسم_المستخدم"] in self.الحسابات:
            return {"نجاح": False, "رسالة": "اسم المستخدم موجود بالفعل"}
            
        if len(بيانات["كلمة_المرور"]) < 8:
            return {"نجاح": False, "رسالة": "كلمة المرور يجب أن تكون 8 أحرف على الأقل"}
            
        حساب_جديد = حساب(
            بيانات["اسم_المستخدم"],
            self._تشفير_كلمة_المرور(بيانات["كلمة_المرور"]),
            بيانات["البريد_الإلكتروني"]
        )
        
        self.الحسابات[بيانات["اسم_المستخدم"]] = حساب_جديد
        
        # إنشاء القوائم النموذجية
        for اسم_قائمة in self.القوائم_النموذجية:
            حساب_جديد.إنشاء_قائمة(اسم_قائمة)
            
        return {"نجاح": True, "رسالة": "تم إنشاء الحساب بنجاح", "حساب": حساب_جديد}
        
    def تسجيل_الدخول(self, اسم_المستخدم: str, كلمة_المرور: str) -> Dict:
        """
        تسجيل دخول المستخدم وإنشاء جلسة جديدة
        """
        if اسم_المستخدم not in self.الحسابات:
            return {"نجاح": False, "رسالة": "اسم المستخدم أو كلمة المرور غير صحيحة"}
            
        الحساب = self.الحسابات[اسم_المستخدم]
        
        if not self._تحقق_من_كلمة_المرور(كلمة_المرور, الحساب.كلمة_المرور):
            return {"نجاح": False, "رسالة": "اسم المستخدم أو كلمة المرور غير صحيحة"}
            
        # إنشاء جلسة جديدة
        جلسة_جديدة = جلسة(الحساب)
        self.الجلسات_النشطة[جلسة_جديدة.معرف_الجلسة] = جلسة_جديدة
        
        # تحديث آخر زيارة
        الحساب.تسجيل_الدخول()
        
        # منح المكافأة اليومية
        الحساب.التحقق_من_المكافأة_اليومية()
        
        return {
            "نجاح": True,
            "رسالة": "تم تسجيل الدخول بنجاح",
            "جلسة": جلسة_جديدة,
            "حساب": الحساب
        }
        
    def تسجيل_الخروج(self, معرف_الجلسة: str) -> Dict:
        """
        إنهاء جلسة المستخدم
        """
        if معرف_الجلسة in self.الجلسات_النشطة:
            del self.الجلسات_النشطة[معرف_الجلسة]
            return {"نجاح": True, "رسالة": "تم تسجيل الخروج بنجاح"}
        return {"نجاح": False, "رسالة": "الجلسة غير موجودة"}
        
    # ---- القوائم والمهام ----
    def إنشاء_قائمة(self, معرف_الجلسة: str, اسم_القائمة: str) -> Dict:
        """
        إنشاء قائمة جديدة للمستخدم
        """
        جلسة = self._الحصول_على_جلسة(معرف_الجلسة)
        if not جلسة:
            return {"نجاح": False, "رسالة": "الجلسة غير صالحة"}
            
        if len(جلسة.الحساب.قوائم) >= self.الإعدادات_العامة["الحد_الأقصى_للقوائم"]:
            return {"نجاح": False, "رسالة": "لقد وصلت إلى الحد الأقصى للقوائم"}
            
        نتيجة = جلسة.الحساب.إنشاء_قائمة(اسم_القائمة)
        return {"نجاح": True, "رسالة": "تم إنشاء القائمة", "قائمة": نتيجة}
        
    def إضافة_مهمة(self, معرف_الجلسة: str, معرف_القائمة: str, نص_المهمة: str) -> Dict:
        """
        إضافة مهمة جديدة إلى قائمة
        """
        جلسة = self._الحصول_على_جلسة(معرف_الجلسة)
        if not جلسة:
            return {"نجاح": False, "رسالة": "الجلسة غير صالحة"}
            
        قائمة = self._الحصول_على_قائمة(جلسة.الحساب, معرف_القائمة)
        if not قائمة:
            return {"نجاح": False, "رسالة": "القائمة غير موجودة"}
            
        if len(قائمة.المهام) >= self.الإعدادات_العامة["الحد_الأقصى_للمهام"]:
            return {"نجاح": False, "رسالة": "لقد وصلت إلى الحد الأقصى للمهام في هذه القائمة"}
            
        قائمة.إضافة_مهمة(نص_المهمة)
        جلسة.الحساب.كسب_النقاط(5)  # نقاط لإضافة مهمة
        
        return {"نجاح": True, "رسالة": "تمت إضافة المهمة"}
        
    # ---- التحسينات المتقدمة ----
    def إنشاء_تحدي(self, معرف_الجلسة: str, بيانات_التحدي: Dict) -> Dict:
        """
        إنشاء تحدٍ جديد للمستخدم
        """
        # تنفيذ الوظيفة...
        pass
        
    def مشاركة_قائمة(self, معرف_الجلسة: str, معرف_القائمة: str, مستخدمين: List[str]) -> Dict:
        """
        مشاركة قائمة مع مستخدمين آخرين
        """
        # تنفيذ الوظيفة...
        pass
        
    def إنشاء_مجموعة(self, معرف_الجلسة: str, اسم_المجموعة: str) -> Dict:
        """
        إنشاء مجموعة تعاونية
        """
        # تنفيذ الوظيفة...
        pass
        
    # ---- الأدوات المساعدة ----
    def _الحصول_على_جلسة(self, معرف_الجلسة: str) -> Optional['جلسة']:
        """
        الحصول على كائن الجلسة من المعرف مع التحقق من الصلاحية
        """
        if معرف_الجلسة not in self.الجلسات_النشطة:
            return None
            
        جلسة = self.الجلسات_النشطة[معرف_الجلسة]
        
        if جلسة.منتهية_الصلاحية():
            del self.الجلسات_النشطة[معرف_الجلسة]
            return None
            
        return جلسة
        
    def _الحصول_على_قائمة(self, حساب: 'حساب', معرف_القائمة: str) -> Optional['قائمة']:
        """
        الحصول على قائمة من حساب المستخدم
        """
        for قائمة in حساب.قوائم:
            if قائمة.المعرف == معرف_القائمة:
                return قائمة
        return None
        
    def _تشفير_كلمة_المرور(self, كلمة_المرور: str) -> str:
        """
        تشفير كلمة المرور باستخدام SHA-256
        """
        return hashlib.sha256(kلمة_المرور.encode()).hexdigest()
        
    def _تحقق_من_كلمة_المرور(self, كلمة_المرور_المدخلة: str, كلمة_المرور_المشفرة: str) -> bool:
        """
        التحقق من تطابق كلمة المرور
        """
        return self._تشفير_كلمة_المرور(كلمة_المرور_المدخلة) == كلمة_المرور_المشفرة

class حساب:
    """
    فئة تمثل حساب مستخدم في نظام D88
    """
    
    def __init__(self, اسم_المستخدم: str, كلمة_المرور: str, البريد_الإلكتروني: str):
        self.المعرف = hashlib.md5(اسم_المستخدم.encode()).hexdigest()
        self.اسم_المستخدم = اسم_المستخدم
        self.كلمة_المرور = كلمة_المرور
        self.البريد_الإلكتروني = البريد_الإلكتروني
        self.نقاط = 0
        self.مستوى = 1
        self.الرتبة = "مبتدئ"
        self.تاريخ_التسجيل = datetime.now()
        self.آخر_��يارة = datetime.now()
        self.قوائم: List['قائمة'] = []
        self.المكافآت_اليومية = {
            "آخر_استلام": None,
            "متتالية_الأيام": 0
        }
        self.الإحصائيات = {
            "المهام_المكتملة": 0,
            "المهام_المعلقة": 0,
            "القوائم_المنشأة": 0,
            "الأصدقاء": 0
        }
        self.الإعدادات = {
            "إشعارات": True,
            "الوضع_الليلي": False,
            "اللغة": "العربية"
        }
        
    def تسجيل_الدخول(self):
        """
        تحديث وقت آخر زيارة للمستخدم
        """
        self.آخر_زيارة = datetime.now()
        
    def إنشاء_قائمة(self, اسم_القائمة: str) -> 'قائمة':
        """
        إنشاء قائمة جديدة وإضافتها إلى حساب المستخدم
        """
        قائمة_جديدة = قائمة(اسم_القائمة)
        self.قوائم.append(قائمة_جديدة)
        self.الإحصائيات["القوائم_المنشأة"] += 1
        return قائمة_جديدة
        
    def كسب_النقاط(self, الكمية: int):
        """
        إضافة نقاط إلى حساب المستخدم
        """
        self.نقاط += الكمية
        self.تحديث_المستوى()
        
    def التحقق_من_المكافأة_اليومية(self):
        """
        التحقق من استحقاق المكافأة اليومية
        """
        الآن = datetime.now()
        آخر_استلام = self.المكافآت_اليومية["آخر_استلام"]
        
        if not آخر_استلام or (الآن - آخر_استلام).days >= 1:
            # حساب المتتالية
            if (الآن - آخر_استلام).days == 1:  # متتالية
                self.المكافآت_اليومية["متتالية_الأيام"] += 1
            else:
                self.المكافآت_اليومية["متتالية_الأيام"] = 1
                
            # حساب المكافأة (50 نقطة أساسية + 10 لكل يوم متتالي)
            مكافأة = 50 + (self.المكافآت_اليومية["متتالية_الأيام"] * 10)
            self.كسب_النقاط(مكافأة)
            
            self.المكافآت_اليومية["آخر_استلام"] = الآن
            return {"نجاح": True, "مكافأة": مكافأة, "متتالية": self.المكافآت_اليومية["متتالية_الأيام"]}
            
        return {"نجاح": False, "رسالة": "لقد حصلت بالفعل على المكافأة اليومية"}
        
    def تحديث_المستوى(self):
        """
        تحديث مستوى المستخدم بناءً على النقاط
        """
        المستوى_الجديد = self.نقاط // 100 + 1
        if المستوى_الجديد != self.مستوى:
            self.مستوى = المستوى_الجديد
            # تحديث الرتبة إذا لزم الأمر
            for رتبة, بيانات in نظام_D88().الرتب_والمكافآت.items():
                if self.مستوى >= رتبة:
                    self.الرتبة = بيانات["الاسم"]
                    
    def إلى_قاموس(self) -> Dict:
        """
        تحويل كائن الحساب إلى قاموس
        """
        return {
            "المعرف": self.المعرف,
            "اسم_المستخدم": self.اسم_المستخدم,
            "البريد_الإلكتروني": self.البريد_الإلكتروني,
            "نقاط": self.نقاط,
            "مستوى": self.مستوى,
            "الرتبة": self.الرتبة,
            "تاريخ_التسجيل": self.تاريخ_التسجيل.isoformat(),
            "آخر_زيارة": self.آخر_زيارة.isoformat(),
            "عدد_القوائم": len(self.قوائم),
            "الإحصائيات": self.الإحصائيات
        }

class قائمة:
    """
    فئة تمثل قائمة مهام في نظام D88
    """
    
    def __init__(self, الاسم: str):
        self.المعرف = hashlib.md5((الاسم + str(time.time())).encode()).hexdigest()
        self.الاسم = الاسم
        self.المهام: List[Dict] = []
        self.تاريخ_الإنشاء = datetime.now()
        self.آخر_تعديل = datetime.now()
        self.الإعدادات = {
            "مشاركة": False,
            "الألوان": "#FFFFFF",
            "الرمز": "📝"
        }
        
    def إضافة_مهمة(self, نص_المهمة: str):
        """
        إضافة مهمة جديدة إلى القائمة
        """
        مهمة_جديدة = {
            "المعرف": hashlib.md5((نص_المهمة + str(time.time())).encode()).hexdigest(),
            "النص": نص_المهمة,
            "تاريخ_الإضافة": datetime.now(),
            "مكتملة": False,
            "تاريخ_الإكمال": None,
            "الأولوية": "متوسطة",
            "التصنيفات": [],
            "الملحقات": []
        }
        self.المهام.append(مهمة_جديدة)
        self.آخر_تعديل = datetime.now()
        
    def تمييز_كمكتمل(self, معرف_المهمة: str) -> bool:
        """
        تمييز مهمة كمكتملة
        """
        for مهمة in self.المهام:
            if مهمة["المعرف"] == معرف_المهمة:
                مهمة["مكتملة"] = True
                مهمة["تاريخ_الإكمال"] = datetime.now()
                self.آخر_تعديل = datetime.now()
                return True
        return False
        
    def عرض_المهام(self) -> List[Dict]:
        """
        عرض جميع المهام في القائمة
        """
        return self.المهام
        
    def إلى_قاموس(self) -> Dict:
        """
        تحويل كائن القائمة إلى قاموس
        """
        return {
            "المعرف": self.المعرف,
            "الاسم": self.الاسم,
            "عدد_المهام": len(self.المهام),
            "المهام_المكتملة": sum(1 for m in self.المهام if m["مكتملة"]),
            "تاريخ_الإنشاء": self.تاريخ_الإنشاء.isoformat(),
            "آخر_تعديل": self.آخر_تعديل.isoformat()
        }

class جلسة:
    """
    فئة تمثل جلسة مستخدم نشطة
    """
    
    def __init__(self, حساب: 'حساب'):
        self.معرف_الجلسة = hashlib.md5((حساب.اسم_المستخدم + str(time.time())).encode()).hexdigest()
        self.الحساب = حساب
        self.تاريخ_البدء = datetime.now()
        self.تاريخ_انتهاء_الصلاحية = datetime.now() + timedelta(
            hours=نظام_D88().الإعدادات_العامة["مدة_انتهاء_الجلسة"]
        )
        self.نشطة = True
        
    def منتهية_الصلاحية(self) -> bool:
        """
        التحقق من انتهاء صلاحية الجلسة
        """
        return datetime.now() > self.تاريخ_انتهاء_الصلاحية or not self.نشطة
        
    def تمديد_الجلسة(self, ساعات: int):
        """
        تمديد مدة الجلسة
        """
        self.تاريخ_انتهاء_الصلاحية += timedelta(hours=ساعات)
        
    def إلى_قاموس(self) -> Dict:
        """
        تحويل كائن الجلسة إلى قاموس
        """
        return {
            "معرف_الجلسة": self.معرف_الجلسة,
            "اسم_المستخدم": self.الحساب.اسم_المستخدم,
            "تاريخ_البدء": self.تاريخ_البدء.isoformat(),
            "تاريخ_انتهاء_الصلاحية": self.تاريخ_انتهاء_الصلاحية.isoformat()
        }

# نموذج استخدام النظام
if __name__ == "__main__":
    # إنشاء النظام
    نظام = نظام_D88()
    
    # تسجيل حساب جديد
    نتيجة = نظام.تسجيل_حساب_جديد({
        "اسم_المستخدم": "أحمد",
        "كلمة_المرور": "كلمةسر123",
        "البريد_الإلكتروني": "ahmed@example.com"
    })
    
    if نتيجة["نجاح"]:
        print("تم إنشاء الحساب بنجاح!")
        
        # تسجيل الدخول
        نتيجة_تسجيل = نظام.تسجيل_الدخول("أحمد", "كلمةسر123")
        
        if نتيجة_تسجيل["نجاح"]:
            print(f"مرحباً {نتيجة_تسجيل['حساب'].اسم_المستخدم}!")
            print(f"نقاطك: {نتيجة_تسجيل['حساب'].نقاط}")
            print(f"مستواك: {نتيجة_تسجيل['حساب'].مستوى}")
            
            # إضافة مهمة إلى قائمة فارم لفل
            for قائمة in نتيجة_تسجيل['حساب'].قوائم:
                if قائمة.الاسم == "فارم لفل":
                    نظام.إضافة_مهمة(
                        نتيجة_تسجيل['جلسة'].معرف_الجلسة,
                        قائمة.المعرف,
                        "جمع 1000 ذهب"
                    )
                    نظام.إضافة_مهمة(
                        نتيجة_تسجيل['جلسة'].معرف_الجلسة,
                        قائمة.المعرف,
                        "ترقية السيف إلى المستوى 5"
                    )
                    
                    # عرض المهام
                    print("\nالمهام في قائمة فارم لفل:")
                    for مهمة in قائمة.عرض_المهام():
                        print(f"- {مهمة['النص']} (الحالة: {'مكتملة' if مهمة['مكتملة'] else 'غير مكتملة'})")
